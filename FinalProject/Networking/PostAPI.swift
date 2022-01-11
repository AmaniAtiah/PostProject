//
//  PostAPI.swift
//  FinalProject
//
//  Created by Amani Atiah on 15/05/1443 AH.
//

import Foundation
import Alamofire
import SwiftyJSON



class PostAPI: API{
    
  
    static func getAllPost(page: Int, tag: String?, completionHandler: @escaping ([Post], Int)  -> () ) {
        
        var url = baseURL + "/post"
        
        if var myTag = tag {
            myTag = myTag.trimmingCharacters(in: .whitespaces)
            url = "\(baseURL)/tag/\(myTag)/post"
        }
        
        
        let params = [
            "page": "\(page)",
            "limit": "5"
            
        ]
        AF.request(url, parameters: params, encoder: URLEncodedFormParameterEncoder.default, headers: headers).responseJSON { response in
            

            let jsonData = JSON(response.value)
            let data = jsonData["data"]
            let total = jsonData["total"].intValue

            let decoder = JSONDecoder()
            do {
                let posts = try decoder.decode([Post].self, from: data.rawData())
                completionHandler(posts, total)
                
            } catch let error {
                print(error)
            }
         //   print(data)
            
        }
        
    }
    
    static func getAllPostByUser(userId: String, completionHandler: @escaping ([Post])  -> () ) {
        
        var url = "\(baseURL)/user/\(userId)/post"
        
        AF.request(url, headers: headers).responseJSON { response in
            

            let jsonData = JSON(response.value)
            let data = jsonData["data"]

            let decoder = JSONDecoder()
            do {
                let posts = try decoder.decode([Post].self, from: data.rawData())
                completionHandler(posts)
                
            } catch let error {
                print(error)
            }
         //   print(data)
            
        }
        
    }
    
    //MARK: ADD POST API
    static func addNewPost(text: String, image: String, userId: String, tag: [String]?, completionHandler: @escaping () -> ()) {
    
        
        let url = "\(baseURL)/post/create"
        let params = [
            "owner": userId,
            "text": text,
            "image": image,
            "tags": tag ?? []

            
        ] as [String : Any] 
        
        AF.request(url, method: .post,parameters: params, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { response in
            
            switch response.result {
            case .success:
                completionHandler()
                
            case .failure(let error) :
                print(error)
            //    completionHandler()
            }
            
        }
        
        

    }
    static func getPostComments(id: String, completionHandler: @escaping ([Comment]) -> () ) {
        let url = "\(baseURL)/post/\(id)/comment"
        
        
        AF.request(url, headers: headers).responseJSON { response in
            let jsonData = JSON(response.value)
            let data = jsonData["data"]
            let decoder = JSONDecoder()
            do {
                let comments = try decoder.decode([Comment].self, from: data.rawData())
                completionHandler(comments)
                
            } catch let error {
                print(error)
            }
            
        }
    }
    
    static func updatePostInfo(text: String, image: String, postId: String, tag: [String]?, completionHandler: @escaping (Post?) -> ()) {


        let url = "\(baseURL)/post/\(postId)"
        let params = [
          //  "owner": userId,
            "text": text,
            "image": image,
            "tags": tag ?? []


        ] as [String : Any]

        AF.request(url, method: .put,parameters: params, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { response in

            switch response.result {
            case .success:
                let jsonData = JSON(response.value)
                let decoder = JSONDecoder()
                do {
                    let post = try decoder.decode(Post.self, from: jsonData.rawData())
                    
                    completionHandler(post)
                } catch let error {
                    print(error)
                }

            case .failure(let error) :
                print(error)
            //    completionHandler()
            }

        }



    }
    
    
    
    //MARK: COMMENT API
    static func addNewCommentToPost(postId: String, userId: String, message: String, completionHandler: @escaping () -> ()) {
    
        let url = "\(baseURL)/comment/create"
        let params = [
            "post": postId,
            "message": message,
            "owner": userId
            
        ]
        
        AF.request(url, method: .post,parameters: params, encoder: JSONParameterEncoder.default, headers: headers).validate().responseJSON { response in
            
            switch response.result {
            case .success:
                completionHandler()
                
            case .failure(let error) :
                print(error)
            //    completionHandler()
            }
            
        }
        
        

    }
    

    
    
    // MARK: TAG API
      static func getAllTags(completionHandler: @escaping ([String])  -> () ) {
          
           let url = baseURL + "/tag"
          
      
          AF.request(url, headers: headers).responseJSON { response in
              

              let jsonData = JSON(response.value)
              let data = jsonData["data"]
              let decoder = JSONDecoder()
              do {
                  let tags = try decoder.decode([String].self, from: data.rawData())
                  completionHandler(tags)
                  
              } catch let error {
                  print(error)
              }
           //   print(data)
              
          }
          
      }
    
    

}
