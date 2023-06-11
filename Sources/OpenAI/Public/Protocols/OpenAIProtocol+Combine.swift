//
//  OpenAIProtocol+Combine.swift
//  
//
//  Created by Sergii Kryvoblotskyi on 03/04/2023.
//

#if canImport(Combine)

import Combine
import Foundation

@available(iOS 13.0, *)
@available(tvOS 13.0, *)
@available(macOS 10.15, *)
@available(watchOS 6.0, *)
public struct CancelPublisher<Output, Failure> where Failure : Error {
    var publisher: AnyPublisher<Output, Failure>
    var task: URLSessionDataTask?
    
    func cancel() {
        if let task = self.task {
            task.cancel()
        }
    }

    func sink(receiveCompletion: @escaping (Subscribers.Completion<Failure>) -> Void,
              receiveValue: @escaping (Output) -> Void) -> AnyCancellable {
        publisher.sink(receiveCompletion: receiveCompletion, receiveValue: receiveValue)
    }
}

@available(iOS 13.0, *)
@available(tvOS 13.0, *)
@available(macOS 10.15, *)
@available(watchOS 6.0, *)
public extension OpenAIProtocol {

    func completions(query: CompletionsQuery) -> AnyPublisher<CompletionsResult, Error> {
        Future<CompletionsResult, Error> {
            completions(query: query, completion: $0)
        }
        .eraseToAnyPublisher()
    }
    
    func completionsStream(query: CompletionsQuery) -> CancelPublisher<Result<CompletionsResult, Error>, Error> {
        let progress = PassthroughSubject<Result<CompletionsResult, Error>, Error>()
        let task = completionsStream(query: query) { result in
            progress.send(result)
        } completion: { error in
            if let error {
                progress.send(completion: .failure(error))
            } else {
                progress.send(completion: .finished)
            }
        }
        return CancelPublisher(publisher: progress.eraseToAnyPublisher(), task: task)
    }

    func images(query: ImagesQuery) -> AnyPublisher<ImagesResult, Error> {
        Future<ImagesResult, Error> {
            images(query: query, completion: $0)
        }
        .eraseToAnyPublisher()
    }

    func embeddings(query: EmbeddingsQuery) -> AnyPublisher<EmbeddingsResult, Error> {
        Future<EmbeddingsResult, Error> {
            embeddings(query: query, completion: $0)
        }
        .eraseToAnyPublisher()
    }

    func chats(query: ChatQuery) -> AnyPublisher<ChatResult, Error> {
        Future<ChatResult, Error> {
            chats(query: query, completion: $0)
        }
        .eraseToAnyPublisher()
    }
    
    func chatsStream(query: ChatQuery) -> CancelPublisher<Result<ChatStreamResult, Error>, Error> {
        let progress = PassthroughSubject<Result<ChatStreamResult, Error>, Error>()
        let task = chatsStream(query: query) { result in
            progress.send(result)
        } completion: { error in
            if let error {
                progress.send(completion: .failure(error))
            } else {
                progress.send(completion: .finished)
            }
        }
        return CancelPublisher(publisher: progress.eraseToAnyPublisher(), task: task)
    }
    
    func edits(query: EditsQuery) -> AnyPublisher<EditsResult, Error> {
        Future<EditsResult, Error> {
            edits(query: query, completion: $0)
        }
        .eraseToAnyPublisher()
    }
    
    func model(query: ModelQuery) -> AnyPublisher<ModelResult, Error> {
        Future<ModelResult, Error> {
            model(query: query, completion: $0)
        }
        .eraseToAnyPublisher()
    }
    
    func models() -> AnyPublisher<ModelsResult, Error> {
        Future<ModelsResult, Error> {
            models(completion: $0)
        }
        .eraseToAnyPublisher()
    }
    
    func moderations(query: ModerationsQuery) -> AnyPublisher<ModerationsResult, Error> {
        Future<ModerationsResult, Error> {
            moderations(query: query, completion: $0)
        }
        .eraseToAnyPublisher()
    }

    func audioTranscriptions(query: AudioTranscriptionQuery) -> AnyPublisher<AudioTranscriptionResult, Error> {
        Future<AudioTranscriptionResult, Error> {
            audioTranscriptions(query: query, completion: $0)
        }
        .eraseToAnyPublisher()
    }

    func audioTranslations(query: AudioTranslationQuery) -> AnyPublisher<AudioTranslationResult, Error> {
        Future<AudioTranslationResult, Error> {
            audioTranslations(query: query, completion: $0)
        }
        .eraseToAnyPublisher()
    }
}



#endif
