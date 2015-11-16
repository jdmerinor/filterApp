//
//  ViewController.swift
//  Filterer
//
//  Created by Jack on 2015-09-22.
//  Copyright © 2015 UofT. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    
    //Definitions of the two images
    var filteredImage : imageProcessor?
    var originalImage: UIImage?
    
    //Here are all the ins and outs of the interface
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var secondaryMenu: UIView!
    @IBOutlet var bottomMenu: UIView!
    @IBOutlet var filterButton: UIButton!
    @IBOutlet weak var sliderMenu: UIView!
    @IBOutlet weak var filterSlider: UISlider!
    @IBOutlet weak var compareButton: UIButton!
    
    //Filter buttons outlets:
    @IBOutlet weak var BrightnessButton: UIButton!
    @IBOutlet weak var GrayScaleButton: UIButton!
    @IBOutlet weak var Contrast: UIButton!
    @IBOutlet weak var GreenButton: UIButton!
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var blackAndWhiteButton: UIButton!
    //Array of buttons
    var buttonsArray : [UIButton] = []
    
    
    //Filters applied
    
    var grayScaleFilter = GrayScales(intensity: 0, name: "GrayScale")
    var brightnessFilter = IncreaseBright(intensity: 0, name: "Brightness")
    var contrastFilter = IncreaseConstrast(intensity: 0, name: "IncreaseContrast")
    var greenFilter = IncreaseGreen(intensity: 0, name: "IncreaseGreen")
    var redFilter = IncreaseRed(intensity: 0, name: "IncreaseRed")
    var blueFilter = IncreaseBlue(intensity: 0, name: "IncreaseBlue")
    var blackAndWhiteFilter = BlackAndWhite(intensity: 0, name: "BaW")
    var filterArray : [filter] = []
    
    
    
    //Executed at the beginning of the program
    override func viewDidLoad() {
        super.viewDidLoad()
        //Some properties of the second menu in filters are set
        secondaryMenu.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5) //it makes it a little transparent
        secondaryMenu.translatesAutoresizingMaskIntoConstraints = false //it disables automatic control of the constrains
        
        //Some properties are defined for the intensity menu:
        sliderMenu.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        sliderMenu.translatesAutoresizingMaskIntoConstraints = false
        
        //The filter array is populated
        filterArray.append(grayScaleFilter)
        filterArray.append(brightnessFilter)
        filterArray.append(contrastFilter)
        filterArray.append(greenFilter)
        filterArray.append(redFilter)
        filterArray.append(blueFilter)
        filterArray.append(blackAndWhiteFilter)
        
        originalImage = imageView.image
        
        //creating the longPress gesture recognizer for the image to switch between the original image and the filtered image
        
        let longpress = UILongPressGestureRecognizer(target: self, action: "longPress:")
        longpress.minimumPressDuration = 0.5
        longpress.delegate = self
        imageView.addGestureRecognizer(longpress)
        
        //Setting the compare button to disabled
        compareButton.enabled = false
        
        
        //filterButtons array is populated
        
        buttonsArray.append(BrightnessButton)
        buttonsArray.append(GrayScaleButton)
        buttonsArray.append(Contrast)
        buttonsArray.append(GreenButton)
        buttonsArray.append(redButton)
        buttonsArray.append(blueButton)
        buttonsArray.append(blackAndWhiteButton)
        
        //Creates the thumbnails for the buttons
        createTumbnails()
    }
    
    // MARK: Share button
    @IBAction func onShare(sender: UIButton) {
        
        filteredImage?.imagen = originalImage
        filteredImage?.applyEffects(filterArray)
        let finalImage = filteredImage?.imagen
        let activityController = UIActivityViewController(activityItems: [finalImage!], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = sender
        activityController.popoverPresentationController?.sourceRect = sender.bounds
        presentViewController(activityController, animated: true, completion: nil)
    }
    
    // MARK: New Photo
    @IBAction func onNewPhoto(sender: UIButton) {
        
        //The actionSheet with the different options are created
        let actionSheet = UIAlertController(title: "New Photo", message: nil, preferredStyle: .ActionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .Default, handler: { action in
            self.showCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Album", style: .Default, handler: { action in
            self.showAlbum()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        //The position of the popover is defined for the
        actionSheet.popoverPresentationController?.sourceView = sender
        actionSheet.popoverPresentationController?.sourceRect = sender.bounds
        
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    //Method used to show the camera and get the image
    func showCamera() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .Camera
        
        
        
        presentViewController(cameraPicker, animated: true, completion: nil)
    }
    
    func showAlbum() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .PhotoLibrary
        
        presentViewController(cameraPicker, animated: true, completion: nil)
    }
    
    // MARK: UIImagePickerControllerDelegate used to get the image and dismiss the picker when it's done
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        dismissViewControllerAnimated(true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            originalImage = image
            resizeImageToWork()
            resetFiltersToDefault()
            createTumbnails()
        }
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Filter Menu
    @IBAction func onFilter(sender: UIButton) {
        hideIntensityMenu()
        disableOtherButtons(sender)
        if (sender.selected) {
            hideSecondaryMenu()
            sender.selected = false
        } else {
            showSecondaryMenu()
            sender.selected = true
        }
    }
    
    
    //Functions to open and close the secondary menu
    func showSecondaryMenu() {
        view.addSubview(secondaryMenu)
        let bottomConstraint = secondaryMenu.bottomAnchor.constraintEqualToAnchor(bottomMenu.topAnchor)
        let leftConstraint = secondaryMenu.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        let rightConstraint = secondaryMenu.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
        
        let heightConstraint = secondaryMenu.heightAnchor.constraintEqualToConstant(90)
        
        NSLayoutConstraint.activateConstraints([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        //Creating thumbnails for the buttons
        createTumbnails()
        
        view.layoutIfNeeded()
        
        self.secondaryMenu.alpha = 0
        UIView.animateWithDuration(0.4) {
            self.secondaryMenu.alpha = 1.0
        }
    }
    
    func hideSecondaryMenu() {
        UIView.animateWithDuration(0.4, animations: {
            self.secondaryMenu.alpha = 0
            }) { completed in
                if completed == true {
                    self.secondaryMenu.removeFromSuperview()
                }
        }
    }
    
    //Functions to open and close the intensity menu when needed
    
    func showIntensityMenu(selectedFilter : UIButton){
        view.addSubview(sliderMenu)
        
        //the position constrains are defined
        let bottomConstraint = sliderMenu.bottomAnchor.constraintEqualToAnchor(secondaryMenu.topAnchor)
        let leftConstraint = sliderMenu.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        let rightConstraint = sliderMenu.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
        
        let heightConstraint = sliderMenu.heightAnchor.constraintEqualToConstant(44)
        
        NSLayoutConstraint.activateConstraints([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        view.layoutIfNeeded()
        self.sliderMenu.alpha = 0
        UIView.animateWithDuration(0.4) {
            self.sliderMenu.alpha = 1.0
        }
        
        if selectedFilter == GrayScaleButton {
            filterSlider.value = grayScaleFilter.intensity
        }else if selectedFilter == BrightnessButton {
            filterSlider.value = brightnessFilter.intensity
        }else if selectedFilter == Contrast {
            filterSlider.value = contrastFilter.intensity
        }else if selectedFilter == GreenButton {
            filterSlider.value = greenFilter.intensity
        }else if selectedFilter == redButton {
            filterSlider.value = redFilter.intensity
        }else if selectedFilter == blueButton {
            filterSlider.value = blueFilter.intensity
        }else if selectedFilter == blackAndWhiteButton {
            filterSlider.value = blackAndWhiteFilter.intensity
        }
        
    }
    
    
    func hideIntensityMenu() {
        UIView.animateWithDuration(0.4, animations: {
            self.sliderMenu.alpha = 0
            }) { completed in
                if completed == true {
                    self.sliderMenu.removeFromSuperview()
                }
        }
    }
    
    
    //IBActions of the filters
    @IBAction func filterButtonAction(sender: UIButton) {
        disableOtherButtons(sender)
        if sender.selected {
            hideIntensityMenu()
            sender.selected = false
        }else{
            showIntensityMenu(sender)
            sender.selected = true
        }
    }
    
    //Function that disables anyother filter button if other one is selected
    func disableOtherButtons(sender: UIButton){
        for thisbutton in buttonsArray{
            if thisbutton != sender {
                thisbutton.selected = false
            }
        }
    }
    
    
    //Everytime the slidervalue changes refresh the filters
    @IBAction func filterSlider(sender: UISlider) {
        var selectedFilter = getSelectedFilter()
        
        selectedFilter?.intensity = sender.value
        
        resizeImageToWork()
        filteredImage?.applyEffects(filterArray)
        imageView.image = filteredImage?.imagen
        
        var counter = 0
        for thisFilter in filterArray {
            if thisFilter.intensity == 0 {
                counter = counter + 1
            }
        }
        
        if counter == filterArray.count { //There are no filters applied, the compare button must be disabled
            compareButton.enabled = false
            imageView.image = originalImage //So it won't show the worst quality image
        }else {
            compareButton.enabled = true
        }
        
    }
    
    //Function to get the selected button in the filter menu
    func getSelectedFilter() ->filter?{
        for thisButton in buttonsArray {
            if thisButton.selected {
                
                if thisButton == GrayScaleButton {
                    return grayScaleFilter
                }else if thisButton == BrightnessButton {
                    return brightnessFilter
                }else if thisButton == Contrast {
                    return contrastFilter
                }else if thisButton == GreenButton {
                    return greenFilter
                }else if thisButton == redButton {
                    return redFilter
                }else if thisButton == blueButton {
                    return blueFilter
                }else if thisButton == blackAndWhiteButton {
                    return blackAndWhiteFilter
                }
            }
        }
        return nil
    }
    
    //Resize the image to make it lighter to work with, but the original quality would be recovery in the share
    func resizeImageToWork (){
        //Resizing it for easy work
        let newSize = CGSize(width: (originalImage?.size.width)!/3, height: (originalImage?.size.height)!/3)
        UIGraphicsBeginImageContext(newSize)
        originalImage?.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        filteredImage = imageProcessor(imagen: UIGraphicsGetImageFromCurrentImageContext())
        UIGraphicsEndImageContext()
    }
    
    
    //the compare button switching function
    @IBAction func compareButtonAction(sender: UIButton) {
        switchImages()
    }
    
    //The image pressLong function for the imageView
    
    func longPress(sender: UILongPressGestureRecognizer!) {
        
        if (sender.state == UIGestureRecognizerState.Ended) {
            
            switchImages()
            
        } else if (sender.state == UIGestureRecognizerState.Began) {
            
            switchImages()
            
        }
        
    }
    
    //Switch between the original image and the filtered image
    func switchImages(){
        if filteredImage?.imagen != nil && compareButton.enabled {
            UIView.transitionWithView(imageView, duration: 0.2, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
                
                if self.imageView.image == self.originalImage { //show the filtered image
                    self.imageView.image = self.filteredImage?.imagen
                }else{ //Show the original image
                    self.imageView.image = self.originalImage
                }
                
                
                }, completion: nil)
            
        }
    }
    
    //It creates and puts the tumbnails for the buttons with the preview of the filter
    func createTumbnails (){
        
        
        for thisButton in buttonsArray{
            
            //resize the image
            var imagenBoton = resizeImage(originalImage!, newHeight: 90)
            
            if thisButton == GrayScaleButton {
                grayScaleFilter.intensity = 0.8
                grayScaleFilter.filter(&imagenBoton)
            }else if thisButton == BrightnessButton {
                brightnessFilter.intensity = 0.7
                brightnessFilter.filter(&imagenBoton)
            }else if thisButton == Contrast {
                contrastFilter.intensity = 0.8
                contrastFilter.filter(&imagenBoton)
            }else if thisButton == GreenButton {
                greenFilter.intensity = 0.8
                greenFilter.filter(&imagenBoton)
            }else if thisButton == redButton {
                redFilter.intensity = 0.8
                redFilter.filter(&imagenBoton)
            }else if thisButton == blueButton {
                blueFilter.intensity = 0.8
                blueFilter.filter(&imagenBoton)
            }else if thisButton == blackAndWhiteButton {
                blackAndWhiteFilter.intensity = 0.8
                blackAndWhiteFilter.filter(&imagenBoton)
            }
            
            
            thisButton.setBackgroundImage(imagenBoton, forState: .Normal)
            thisButton.setBackgroundImage(imagenBoton, forState: .Selected)
            
        }
        resetFiltersToDefault()
    }
    
    
    //Resizing image function for thumbnails
    func resizeImage(image: UIImage, newHeight: CGFloat) -> UIImage {
        
        let scale = newHeight / image.size.height
        let newWidth = image.size.width * scale
        UIGraphicsBeginImageContext(CGSizeMake(newHeight, newWidth))
        image.drawInRect(CGRectMake(0, 0, newHeight, newWidth))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func resetFiltersToDefault(){
        for var thisFilter in filterArray{
            thisFilter.intensity = 0
        }
    }
    
}

