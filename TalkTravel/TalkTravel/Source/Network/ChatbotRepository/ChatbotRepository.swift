import Foundation
import RxSwift

final class ChatbotRepository {
    func getChatRooms(completion: @escaping ((ChatHistoryDTO) -> Void)) {
        GETService.shared.getService(from: AppConstants.baseURL + "/api/v1/chat_rooms",
                                                     callback: { (data: ChatHistoryDTO?, error) in
            guard let data = data else {
                return
            }
            completion(data)
        })
    }
    
    func createChatRoom(name: String,
                        completion: @escaping ((CreateChatDTO) -> Void)) {
        let body = ["name": name]
        PostService.shared.postService(with: body,
                                       from: AppConstants.baseURL + "/api/v1/chat_rooms",
                                       callback: { (data: CreateChatDTO?, error) in
            guard let data = data else {
                return
            }
            completion(data)
        })
    }
    
    func chatDetailPost(id: String,
                        prompt: String,
                        isChatbot: Bool,
                        completion: @escaping ((ChatDetailDTO) -> Void)) {
        let body = ["message": prompt,
                    "is_chatbot": isChatbot] as [String : Any]
        PostService.shared.postService(with: body,
                                       from: AppConstants.baseURL + "/api/v1/chat_rooms/\(id)/records",
                                       callback: { (data: ChatDetailDTO?, error) in
            guard let data = data else {
                return
            }
            completion(data)
        })
    }
    
    func getChatbotHistory(id: String,
                           completion: @escaping((ChatDetailHistoryDTO) -> Void)) {
        GETService.shared.getService(from: AppConstants.baseURL + "/api/v1/chat_rooms/\(id)/records",
                                     callback: { (data: ChatDetailHistoryDTO?, error) in
            guard let data = data else {
                return
            }
            completion(data)
        })
    }
}
