//
//  APISniper.swift
//
//
//  Created by SS-113 on 26/09/16.
//  Copyright © 2016 singsys. All rights reserved.
//

import Foundation
import AFNetworking

class APISniper : NSObject
{
    typealias CompleteBlock = ( _ operation: AFHTTPRequestOperation,  _ responseObject: Any) -> Void
    typealias ErrorBlock = ( _ operation: AFHTTPRequestOperation?,  _ error: Error) -> Void
    
    func httpManager(baseUrl: String) -> AFHTTPRequestOperationManager
    {
        let httpManager = AFHTTPRequestOperationManager(baseURL: URL(string: baseUrl))
        
        let requestSerializer : AFJSONRequestSerializer = AFJSONRequestSerializer()
        
        requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        
        httpManager.requestSerializer = requestSerializer
        
        return httpManager
    }
    
    //    func getDataFromWebAPI(_ requestData: NSMutableDictionary, _ completeBlock: @escaping CompleteBlock, _ errorBlock: @escaping ErrorBlock)
    //    {
    //        self.httpManager().post("", parameters: requestData, success: completeBlock, failure: errorBlock)
    //    }
    //
    //    func passData(_ requestData: NSMutableDictionary, _ completeBlock: @escaping CompleteBlock, _ errorBlock: @escaping ErrorBlock)
    //    {
    //        self.httpManager().post("", parameters: requestData, success: completeBlock, failure: errorBlock)
    //    }
    
    
    // MARK: Post Method
    func getDataFromWebAPItoken(_ url: String, _ requestData: NSMutableDictionary, _ completeBlock: @escaping CompleteBlock, _ errorBlock: @escaping ErrorBlock)
    {
        self.httpManager(baseUrl: WebAPI.BASE_URLs).post(url, parameters: requestData, success: completeBlock, failure: errorBlock)
        
    }
    func getDataFromWebAPI(_ url: String, _ requestData: NSMutableDictionary, _ completeBlock: @escaping CompleteBlock, _ errorBlock: @escaping ErrorBlock)
    {
        self.httpManager(baseUrl: WebAPI.BASE_URL).post(url + "?access_token=" + access_token, parameters: requestData, success: completeBlock, failure: errorBlock)
    }
    
       
    
    
        // MARK: Post Method
    func getDataFromSignup(_ url: String, _ requestData: NSMutableDictionary,_ photoData: NSData,_ documentArray: NSArray, completeBlock: @escaping CompleteBlock, _ errorBlock: @escaping ErrorBlock)
    {
        
        self.httpManager(baseUrl: WebAPI.BASE_URL).post(url + "?access_token=" + access_token, parameters: requestData, constructingBodyWith: { formData -> Void in
            if photoData.length > 0
            {
                formData.appendPart(withFileData: photoData as Data, name: "user_image", fileName: "image.jpeg", mimeType: "image/jpeg")
            }
            for i in 0 ..< documentArray.count
            {
                if (documentArray.object(at: i) as? NSDictionary)?.object(forKey: "file_type") as! String == "pdf"
                {
                    
                    formData.appendPart(withFileData: (documentArray.object(at: i) as? NSDictionary)?.object(forKey: "img_data") as! Data, name: "documents[]", fileName: "documents.pdf", mimeType: "documents/pdf")
                    
                }else if ( (documentArray.object(at: i) as? NSDictionary)?.object(forKey: "file_type") as! String).lowercased() == "png" || ( (documentArray.object(at: i) as? NSDictionary)?.object(forKey: "file_type") as! String).lowercased() ==  "jpg" || ( (documentArray.object(at: i) as? NSDictionary)?.object(forKey: "file_type") as! String).lowercased() ==  "jpeg"
                {
                    formData.appendPart(withFileData: (documentArray.object(at: i) as? NSDictionary)?.object(forKey: "img_data") as! Data, name: "documents[]", fileName: "image.jpeg", mimeType: "image/jpeg")
                }
                
            }
            
            
            
        }, success: completeBlock, failure: errorBlock)
        
    }
    
    
    
    
    
    
    
    // MARK: Get Method
    func getDataFromWebAPIWithGet(_ url: String, _ requestData: NSMutableDictionary, _ completeBlock: @escaping CompleteBlock, _ errorBlock: @escaping ErrorBlock)
    {
        self.httpManager(baseUrl: WebAPI.BASE_URL).get(url, parameters: requestData, success: completeBlock, failure: errorBlock)
    }
    
    
    
    
    func uploadImages(_ url: String, _ requestData: NSMutableDictionary, _ photoData: NSData, completeBlock: @escaping CompleteBlock, _ errorBlock: @escaping ErrorBlock)
    {
        self.httpManager(baseUrl: url).post("", parameters: requestData, constructingBodyWith: { formData -> Void in
            if photoData.length > 0
            {
                formData.appendPart(withFileData: photoData as Data, name: "profile_image", fileName: "image.jpeg", mimeType: "image/jpeg")
            }
            
        }, success: completeBlock, failure: errorBlock)
    }
    
    
    
    func edituploadImages(_ url: String, _ requestData: NSMutableDictionary, _ photoData: NSData, completeBlock: @escaping CompleteBlock, _ errorBlock: @escaping ErrorBlock)
    {
        self.httpManager(baseUrl: url).post("", parameters: requestData, constructingBodyWith: { formData -> Void in
            
            if photoData.length > 0
            {
                formData.appendPart(withFileData: photoData as Data, name: "image", fileName: "image.jpeg", mimeType: "image/jpeg")
            }
            
        }, success: completeBlock, failure: errorBlock)
    }
    
    
    
    func uploadQualification(_ url: String, _ requestData: NSMutableDictionary, _ photoData: NSData, completeBlock: @escaping CompleteBlock, _ errorBlock: @escaping ErrorBlock)
    {
        self.httpManager(baseUrl: url).post("", parameters: requestData, constructingBodyWith: { formData -> Void in
            
            
            if photoData.length > 0
            {
                formData.appendPart(withFileData: photoData as Data, name: "image", fileName: "image.jpeg", mimeType: "image/jpeg")
            }
            
        }, success: completeBlock, failure: errorBlock)
    }
    
    
    func toUploadMultipleImagesOnServer(_ url: String,_ signatureImage: Data,  requestData: NSMutableDictionary,  per_imageArray: NSArray,pgde_imageArray: NSArray,bachde_imageArray: NSArray,postgd_imageArray: NSArray,mem_imageArray: NSArray, completeBlock: @escaping CompleteBlock,  errorBlock: @escaping ErrorBlock)
    {
        self.httpManager(baseUrl: url).post("", parameters: requestData, constructingBodyWith: { formData -> Void in
            
            
            
            for i in 0 ..< per_imageArray.count
            {
                if per_imageArray.object(at:  i) is UIImage
                {
                    formData.appendPart(
                        withFileData: UIImageJPEGRepresentation(per_imageArray.object(at: i) as! UIImage, 0.8)!,
                        name: "personal_upload[]",
                        fileName: "image.jpeg",
                        mimeType: "image/jpeg")
                }
            }
            for i in 0 ..< pgde_imageArray.count
            {
                if pgde_imageArray.object(at:  i) is UIImage
                {
                    formData.appendPart(
                        withFileData: UIImageJPEGRepresentation(pgde_imageArray.object(at: i) as! UIImage, 0.8)!,
                        name: "deploma_upload[]",
                        fileName: "image.jpeg",
                        mimeType: "image/jpeg")
                }
            }
            for i in 0 ..< bachde_imageArray.count
            {
                if bachde_imageArray.object(at:  i) is UIImage
                {
                    formData.appendPart(
                        withFileData: UIImageJPEGRepresentation(bachde_imageArray.object(at: i) as! UIImage, 0.8)!,
                        name: "bachelor_upload[]",
                        fileName: "image.jpeg",
                        mimeType: "image/jpeg")
                }
            }
            
            for i in 0 ..< postgd_imageArray.count
            {
                if postgd_imageArray.object(at:  i) is UIImage
                {
                    formData.appendPart(
                        withFileData: UIImageJPEGRepresentation(postgd_imageArray.object(at: i) as! UIImage, 0.8)!,
                        name: "postgraduate_upload[]",
                        fileName: "image.jpeg",
                        mimeType: "image/jpeg")
                }
            }
            for i in 0 ..< mem_imageArray.count
            {
                if mem_imageArray.object(at:  i) is UIImage
                {
                    formData.appendPart(
                        withFileData: UIImageJPEGRepresentation(mem_imageArray.object(at: i) as! UIImage, 0.8)!,
                        name: "membership_certificate_upload[]",
                        fileName: "image.jpeg",
                        mimeType: "image/jpeg")
                }
            }
            
            if signatureImage.count > 0
            {
                formData.appendPart(withFileData: signatureImage as Data, name: "esignature_upload", fileName: "image.jpeg", mimeType: "image/jpeg")
            }
        }, success: completeBlock, failure: errorBlock)
        
    }
    
//    MARK:- Uplaod Documents(images & pdf)
   
    func uploadDocuments(_ url: String, _ requestData: NSMutableDictionary,_ documentArray: NSArray,imageArray: NSArray, completeBlock: @escaping CompleteBlock, _ errorBlock: @escaping ErrorBlock)
    {

        self.httpManager(baseUrl: WebAPI.BASE_URL).post(url + "?access_token=" + access_token, parameters: requestData, constructingBodyWith: { formData -> Void in
            //            if photoData.length > 0
            //            {
            //                formData.appendPart(withFileData: photoData as Data, name: "user_image", fileName: "image.jpeg", mimeType: "image/jpeg")
            //            }
            for i in 0 ..< documentArray.count
            {
                if (documentArray.object(at: i) as? NSDictionary)?.object(forKey: "file_type") as! String == "pdf"
                {
                    if (documentArray.object(at: i) as? NSDictionary)?.object(forKey: "img_data") != nil{
                        formData.appendPart(withFileData: (documentArray.object(at: i) as? NSDictionary)?.object(forKey: "img_data") as! Data, name: "documents[]", fileName: "documents.pdf", mimeType: "documents/pdf")
                    }
                }
            }
            for i in 0 ..< imageArray.count
            {
                if (imageArray.object(at: i) as? NSDictionary)?.object(forKey: "img_data") != nil{
                    formData.appendPart(withFileData: (imageArray.object(at: i) as? NSDictionary)?.object(forKey: "img_data") as! Data, name: "images[]", fileName: "image.jpeg", mimeType: "image/jpeg")
                }
            }
        }, success: completeBlock, failure: errorBlock)

    }

    
    
    
    //    func hitWebServiceWithSerializer(_ url: String, _ requestData: NSMutableDictionary, completeBlock: @escaping CompleteBlock, _ errorBlock: @escaping ErrorBlock)
    //    {
    //        let httpManager = AFHTTPRequestOperationManager(baseURL: URL(string: url))
    //        let requestSerializer : AFJSONRequestSerializer = AFJSONRequestSerializer()
    //        requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
    //        requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
    //        httpManager.requestSerializer = requestSerializer
    //        httpManager.post("", parameters: requestData, success: completeBlock, failure: errorBlock)
    //    }
    
    
}
