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
            "{\"contents\":[{\"role\":\"user\",\"parts\":[{\"text\":\"%s\"}]}]}",
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

    private String parseGeminiResponse(String response) throws Exception {
        try {
            System.out.println("Starting to parse response...");
            System.out.println("Response length: " + response.length());
            System.out.println("First 200 characters of response: " + response.substring(0, Math.min(200, response.length())));
            
            // Find the start of the text content by looking for the nested structure
            int candidatesStart = response.indexOf("\"candidates\":");
            if (candidatesStart == -1) {
                System.out.println("No candidates array found in response");
                throw new Exception("No candidates array found in response");
            }
            System.out.println("Found candidates array at position: " + candidatesStart);
            
            int contentStart = response.indexOf("\"content\":", candidatesStart);
            if (contentStart == -1) {
                System.out.println("No content object found in response");
                throw new Exception("No content object found in response");
            }
            System.out.println("Found content object at position: " + contentStart);
            
            int partsStart = response.indexOf("\"parts\":", contentStart);
            if (partsStart == -1) {
                System.out.println("No parts array found in response");
                throw new Exception("No parts array found in response");
            }
            System.out.println("Found parts array at position: " + partsStart);
            
            // Look for the text field within the parts array, accounting for whitespace
            int textStart = response.indexOf("\"text\":", partsStart);
            if (textStart == -1) {
                System.out.println("No text field found in response");
                throw new Exception("No text field found in response");
            }
            System.out.println("Found text field at position: " + textStart);
            
            // Move past the "text":" part and any whitespace
            textStart = response.indexOf("\"", textStart + 7);
            if (textStart == -1) {
                throw new Exception("Invalid text field format - no opening quote found");
            }
            textStart += 1; // Move past the opening quote
            
            // Find the end of the text content by looking for the closing quote
            int textEnd = textStart;
            boolean inEscape = false;
            int braceCount = 0;
            
            while (textEnd < response.length()) {
                char c = response.charAt(textEnd);
                
                if (c == '\\') {
                    inEscape = !inEscape;
                } else if (c == '"' && !inEscape) {
                    // Check if this is the end of the text content
                    int nextChar = textEnd + 1;
                    while (nextChar < response.length() && Character.isWhitespace(response.charAt(nextChar))) {
                        nextChar++;
                    }
                    if (nextChar < response.length() && response.charAt(nextChar) == '}') {
                        break;
                    }
                } else if (c == '{' && !inEscape) {
                    braceCount++;
                } else if (c == '}' && !inEscape) {
                    braceCount--;
                    if (braceCount < 0) {
                        break;
                    }
                }
                
                inEscape = false;
                textEnd++;
            }
            
            if (textEnd >= response.length()) {
                throw new Exception("Invalid text field format - no closing quote found");
            }
            
            // Extract the text content
            String text = response.substring(textStart, textEnd);
            System.out.println("Extracted text length: " + text.length());
            System.out.println("First 100 characters of extracted text: " + text.substring(0, Math.min(100, text.length())));
            
            // Handle escape sequences
            text = text.replace("\\n", "\n")
                      .replace("\\\"", "\"")
                      .replace("\\\\", "\\")
                      .replace("\\r", "\r")
                      .replace("\\t", "\t")
                      .replace("\\b", "\b")
                      .replace("\\f", "\f");
            
            System.out.println("Successfully extracted text content");
            return text;
            
        } catch (Exception e) {
            System.out.println("Error parsing response: " + e.getMessage());
            System.out.println("Full response was: " + response);
            throw new Exception("Failed to parse API response: " + e.getMessage());
        }
    }
} 