package Service;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;

public class GeminiService {
    private static final String API_KEY = "AIzaSyCniaKHzVTxugsJZ6R-OoQ_7bPENr0ai8g";
    private static final String API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent";
    private final HttpClient httpClient;

    public GeminiService() {
        this.httpClient = HttpClient.newBuilder()
                .connectTimeout(Duration.ofSeconds(10))
                .build();
    }

    public String generateWorkoutPlan(String prompt) throws Exception {
        System.out.println("Generating workout plan with prompt: " + prompt);
        String requestBody = createRequestBody(prompt);
        String response = makeApiRequest(requestBody);
        return parseGeminiResponse(response);
    }

    public String generateMealPlan(String prompt) throws Exception {
        System.out.println("Generating meal plan with prompt: " + prompt);
        String requestBody = createRequestBody(prompt);
        String response = makeApiRequest(requestBody);
        return parseGeminiResponse(response);
    }

    private String createRequestBody(String prompt) {
        return String.format(
            "{\"contents\":[{\"parts\":[{\"text\":\"%s\"}]}],\"generationConfig\":{\"temperature\":0.7,\"topK\":40,\"topP\":0.95,\"maxOutputTokens\":2048}}",
            prompt.replace("\"", "\\\"")
        );
    }

    private String makeApiRequest(String requestBody) throws Exception {
        String url = API_URL + "?key=" + API_KEY;
        System.out.println("Making API request to: " + url);
        System.out.println("Request body: " + requestBody);
        
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .header("Content-Type", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString(requestBody))
                .build();

        HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
        System.out.println("API Response status: " + response.statusCode());
        System.out.println("API Response body: " + response.body());
        
        if (response.statusCode() != 200) {
            throw new Exception("API request failed with status code: " + response.statusCode() + 
                              "\nResponse: " + response.body());
        }
        
        return response.body();
    }

    private String parseGeminiResponse(String responseJson) throws Exception {
        try {
            System.out.println("Parsing response: " + responseJson);
            
            // Extract the text from the response
            int textStart = responseJson.indexOf("\"text\":\"");
            if (textStart == -1) {
                throw new Exception("No text field found in response");
            }
            
            textStart += 8; // Skip "text":"
            int textEnd = responseJson.indexOf("\"", textStart);
            if (textEnd == -1) {
                throw new Exception("Invalid text format in response");
            }
            
            String text = responseJson.substring(textStart, textEnd);
            return text.replace("\\n", "\n").replace("\\\"", "\"");
        } catch (Exception e) {
            System.err.println("Error parsing response: " + e.getMessage());
            throw new Exception("Failed to parse API response: " + e.getMessage() + "\nResponse was: " + responseJson);
        }
    }
} 