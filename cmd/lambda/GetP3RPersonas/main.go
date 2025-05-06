package main

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"os"
	"sync"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/feature/dynamodb/attributevalue"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb/types"
	GetPersonaCompendiumErrors "github.com/bradleyGamiMarques/PersonaCompendiumErrors"
	GetPersonaServiceTypes "github.com/bradleyGamiMarques/get-persona-service-types"
)

var (
	svc       *dynamodb.Client
	tableName string
	initOnce  sync.Once
	initError error
)

var majorArcanaOrder = []string{
	"Fool", "Magician", "Priestess", "Empress", "Emperor", "Hierophant",
	"Lovers", "Chariot", "Justice", "Hermit", "Fortune", "Strength",
	"Hanged Man", "Death", "Temperance", "Devil", "Tower", "Star",
	"Moon", "Sun", "Judgement", "World",
}

func initAWS(ctx context.Context) error {
	tableName = os.Getenv("DYNAMODB_TABLE_NAME")
	if tableName == "" {
		log.Println("Internal Server Error: DYNAMODB_TABLE_NAME environment variable not set")
		return fmt.Errorf("DYNAMODB_TABLE_NAME environment variable not set")
	}

	cfg, err := config.LoadDefaultConfig(ctx)
	if err != nil {
		log.Printf("Internal Server Error: failed to load configuration: %v\n", err)
		return fmt.Errorf("failed to load configuration: %v", err)
	}

	svc = dynamodb.NewFromConfig(cfg)
	return nil
}

func fetchPersonasByArcana(ctx context.Context, arcanas []string) map[string][]GetPersonaServiceTypes.P3RPersonaListItem {
	grouped := make(map[string][]GetPersonaServiceTypes.P3RPersonaListItem, len(majorArcanaOrder))
	for _, arcana := range majorArcanaOrder {
		grouped[arcana] = []GetPersonaServiceTypes.P3RPersonaListItem{}
	}

	var wg sync.WaitGroup
	var mu sync.Mutex

	for _, arcana := range arcanas {
		wg.Add(1)
		go func(arcana string) {
			defer wg.Done()

			input := &dynamodb.QueryInput{
				TableName:              aws.String(tableName),
				KeyConditionExpression: aws.String("Arcana = :hk"),
				ExpressionAttributeValues: map[string]types.AttributeValue{
					":hk": &types.AttributeValueMemberS{Value: arcana},
				},
				ProjectionExpression: aws.String("Arcana, PersonaLevel, PersonaName, IsDLC"),
			}

			result, err := svc.Query(ctx, input)
			if err != nil {
				log.Printf("Error querying arcana %s: %v", arcana, err)
				return
			}

			var personas []GetPersonaServiceTypes.P3RPersonaListItem
			for _, item := range result.Items {
				var persona GetPersonaServiceTypes.P3RPersonaListItem
				if err := attributevalue.UnmarshalMap(item, &persona); err != nil {
					log.Printf("Error unmarshalling persona for arcana %s: %v", arcana, err)
					return
				}
				personas = append(personas, persona)
			}

			mu.Lock()
			grouped[arcana] = personas
			mu.Unlock()
		}(arcana)
	}

	wg.Wait()
	return grouped
}

func flattenGroupedPersonas(grouped map[string][]GetPersonaServiceTypes.P3RPersonaListItem) []GetPersonaServiceTypes.P3RPersonaListItem {
	// Step 1: Calculate total capacity needed
        total := 0
	for _, personas := range grouped {
		total += len(personas)
	}

	// Step 2: Preallocate the slice with total capacity
	flattened := make([]GetPersonaServiceTypes.P3RPersonaListItem, 0, total)
	var flattened []GetPersonaServiceTypes.P3RPersonaListItem
	for _, arcana := range majorArcanaOrder {
		flattened = append(flattened, grouped[arcana]...)
	}
	return flattened
}

func Handle(ctx context.Context, request events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	initOnce.Do(func() {
		initError = initAWS(ctx)
	})
	if initError != nil {
		log.Printf("Internal Server Error: %v", initError)
		errorResponse := GetPersonaCompendiumErrors.InternalServerError("Something went wrong", request.Path)
		return GetPersonaCompendiumErrors.JSONResponse(errorResponse)
	}

	var inputBody GetPersonaServiceTypes.GetP3RPersonasRequest
	if err := json.Unmarshal([]byte(request.Body), &inputBody); err != nil {
		log.Printf("Bad Request: failed to parse body: %v", err)
		errorResponse := GetPersonaCompendiumErrors.BadRequestError("Invalid request body", request.Path)
		return GetPersonaCompendiumErrors.JSONResponse(errorResponse)
	}

	if len(inputBody.Arcanas) == 0 {
		log.Println("Bad Request: missing arcanas in request body")
		errorResponse := GetPersonaCompendiumErrors.BadRequestError("Missing arcanas", request.Path)
		return GetPersonaCompendiumErrors.JSONResponse(errorResponse)
	}

	grouped := fetchPersonasByArcana(ctx, inputBody.Arcanas)
	orderedResponse := flattenGroupedPersonas(grouped)

	responseBody, err := json.Marshal(orderedResponse)
	if err != nil {
		log.Printf("Internal Server Error: failed to marshal response: %v", err)
		errorResponse := GetPersonaCompendiumErrors.InternalServerError("Something went wrong", request.Path)
		return GetPersonaCompendiumErrors.JSONResponse(errorResponse)
	}

	return events.APIGatewayProxyResponse{
		StatusCode:      200,
		Headers:         map[string]string{"Content-Type": "application/json", "Access-Control-Allow-Origin": "*"},
		Body:            string(responseBody),
		IsBase64Encoded: false,
	}, nil
}

func main() {
	lambda.Start(Handle)
}
