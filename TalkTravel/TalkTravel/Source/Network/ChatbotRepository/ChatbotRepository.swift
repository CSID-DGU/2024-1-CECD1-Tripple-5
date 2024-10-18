import Foundation
import RxSwift

final class ChatbotRepository {
    func getReadChatRooms(userId: String,
                          completion: @escaping ((GetReadChatRooms) -> Void)) {
        GETService.shared.getService(from: AppConstants.baseURL + "/api/v1/users/\(userId)/chat_rooms",
                                     callback: { (data: GetReadChatRooms?, error) in
            guard let data = data else {
                return
            }
            completion(data)
        })
    }
    
    func postCreateChatRoom(userId: String,
                            chatRoomName: String,
                            completion: @escaping ((PostCreateChatRoomDTO) -> Void)) {
        let body = ["chat_room_name": chatRoomName]
        PostService.shared.postService(with: body,
                                       from: AppConstants.baseURL + "/api/v1/users/\(userId)/chat_rooms",
                                       callback: { (data: PostCreateChatRoomDTO?, error) in
            guard let data = data else {
                return
            }
            completion(data)
        })
    }
    
    func getReadChatRoom(chatRoomId: String,
                         completion: @escaping ((GetReadChatRoomDTO) -> Void)) {
        GETService.shared.getService(from: AppConstants.baseURL + "/api/v1/chat_rooms/\(chatRoomId)",
                                     callback: { (data: GetReadChatRoomDTO?, error) in
            guard let data = data else {
                return
            }
            completion(data)
        })
    }
    
    func deleteChatRoom(chatRoomId: String,
                        completion: @escaping ((DeleteChatRoomDTO) -> Void)) {
        DELETEService.shared.deleteService(from: AppConstants.baseURL + "/api/v1/chat_rooms/\(chatRoomId)",
                                           callback: { (data: DeleteChatRoomDTO?, error) in
            guard let data = data else {
                return
            }
            completion(data)
        })
    }
    
    func getReadChatRecords(chatRoomId: String,
                            completion: @escaping ((GetReadChatRecordsDTO) -> Void)) {
        GETService.shared.getService(from: AppConstants.baseURL + "/api/v1/chat_rooms/\(chatRoomId)",
                                     callback: { (data: GetReadChatRecordsDTO?, error) in
            guard let data = data else {
                return
            }
            completion(data)
        })
    }
    
    func postCreateChatRecords(chatRoomId: String,
                               message: String,
                               isChatbot: Bool,
                               completion: @escaping ((PostCreateChatRecordsDTO) -> Void)) {
        let body: [String: Any] = ["message": message,
                                   "is_chatbot": isChatbot]
        PostService.shared.postService(with: body,
                                       from: AppConstants.baseURL + "/api/v1/chat_rooms/\(chatRoomId)/records",
                                       callback: { (data: PostCreateChatRecordsDTO?, error) in
            guard let data = data else {
                return
            }
            completion(data)
        })
    }
    
    func deleteChatRecords(chatRecordId: String,
                           completion: @escaping ((DeleteChatRecordDTO) -> Void)) {
        DELETEService.shared.deleteService(from: AppConstants.baseURL + "/api/v1/chat_records/\(chatRecordId)",
                                           callback: { (data: DeleteChatRecordDTO?, error) in
            guard let data = data else {
                return
            }
            completion(data)
        })
    }
}
extension ChatbotRepository {
    ///REGACY
    func getChatRooms(completion: @escaping ((ChatHistoryDTO) -> Void)) {
        GETService.shared.getService(from: AppConstants.baseURL + "/api/v1/chat_rooms",
                                                     callback: { (data: ChatHistoryDTO?, error) in
            guard let data = data else {
                return
            }
            completion(data)
        })
    }
    
    ///REGACY
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
    
    ///REGACY
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
    
    ///REGACY
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
