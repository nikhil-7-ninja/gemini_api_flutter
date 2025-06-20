// Copyright 2024 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

/// Google generative AI SDK API bindings for Dart.
///
/// The Google Generative AI SDK for Dart allows developers to use
/// state-of-the-art Large Language Models (LLMs) to build applications.
///
/// Most uses of this library will be through a [GenerativeModel].
/// Here's a simple example of using this API:
///
/// ```dart
/// const apiKey = ...;
///
/// void main() async {
///   final model = GenerativeModel(
///       model: 'gemini-1.5-flash-latest',
///       apiKey: apiKey,
///   );
///
///   final prompt = 'Write a story about a magic backpack.';
///   final content = [Content.text(prompt)];
///   final response = await model.generateContent(content);
///
///   print(response.text);
/// };
/// ```
library;

export 'src/api.dart'
    show
        BatchEmbedContentsResponse,
        BlockReason,
        Candidate,
        CitationMetadata,
        CitationSource,
        ContentEmbedding,
        CountTokensResponse,
        EmbedContentRequest,
        EmbedContentResponse,
        FinishReason,
        GenerateContentResponse,
        GenerationConfig,
        HarmBlockThreshold,
        HarmCategory,
        HarmProbability,
        PromptFeedback,
        SafetyRating,
        SafetySetting,
        TaskType,
        UsageMetadata;
export 'src/chat.dart' show ChatSession, StartChatExtension;
export 'src/content.dart'
    show
        CodeExecutionResult,
        Content,
        DataPart,
        ExecutableCode,
        FilePart,
        FunctionCall,
        FunctionResponse,
        Language,
        Outcome,
        Part,
        TextPart;
export 'src/error.dart'
    show GenerativeAIException, GenerativeAISdkException, InvalidApiKey, ServerException, UnsupportedUserLocation;
export 'src/function_calling.dart'
    show
        CodeExecution,
        FunctionCallingConfig,
        FunctionCallingMode,
        FunctionDeclaration,
        Schema,
        ResponseMimeType,
        SchemaType,
        Tool,
        ToolConfig;
export 'src/model.dart' show RequestOptions, GeminiApiModel;
