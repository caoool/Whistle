//
//  Image.swift
//  ParseStarterProject
//
//  Created by Yetian Mao on 6/9/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit

class Image: NSObject {
    
//    func init(chosenImage: UIImage, size: CGFloat){
//        let imageView = UIImageView(image: chosenImage)
//        imageView.contentMode = .ScaleAspectFit
//        imageView.frame = CGRectMake(0, 0, size, size)
//        
//        let delete = UIButton()
//        let deleteImage = UIImage(named: "help_photo_delete")
//        delete.frame = CGRectMake(0, 0, deleteImage!.size.height, deleteImage!.size.width)
//        delete.setImage(deleteImage, forState: UIControlState.Normal)
//        imageView.addSubview(delete)
//    }
    
    static func cropToSquare(image originalImage: UIImage) -> UIImage {
        // Create a copy of the image without the imageOrientation property so it is in its native orientation (landscape)
        let contextImage: UIImage = UIImage(CGImage: originalImage.CGImage)!
        
        // Get the size of the contextImage
        let contextSize: CGSize = contextImage.size
        
        let posX: CGFloat
        let posY: CGFloat
        let width: CGFloat
        let height: CGFloat
        
        // Check to see which length is the longest and create the offset based on that length, then set the width and height of our rect
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            width = contextSize.height
            height = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            width = contextSize.width
            height = contextSize.width
        }
        
        let rect: CGRect = CGRectMake(posX, posY, width, height)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImageRef = CGImageCreateWithImageInRect(contextImage.CGImage, rect)
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(CGImage: imageRef, scale: originalImage.scale, orientation: originalImage.imageOrientation)!
        
        return image
    }
    
    static func resizeImage(image: UIImage, width: CGFloat, height: CGFloat) -> UIImage {
        let size : CGSize = CGSizeMake(width, height)
        let rect : CGRect = CGRectMake(0, 0, size.width, size.height)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        image.drawInRect(rect)
        
        let resized : UIImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext()
        return resized
    }
    
}