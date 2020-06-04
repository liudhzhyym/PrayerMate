//
//  HomeVC+PresenterDelegate.swift
//  PrayerMate
//
//  Created by eman shedeed on 3/19/20.
//  Copyright © 2020 eman shedeed. All rights reserved.
//

import Foundation
/// This is a class created for conform to HomeView to display prayer times after fetching from API
extension HomeViewController:HomeViewControllerProtocol{
  
  
    /**
     protcol delegate function called when there was an error fetching  data
     - Parameters:
     */
    func showError(error: String) {
        DispatchQueue.main.async {
            Helper.showAlert(title: "", message: error, VC: self)
            self.activityIndicator.stopAnimating()
        }
    }
    /**
     protcol delegate function called when success to fetch data
     - Parameters:
     */
    func fetchDataSucess() {
        prayerTimesArray = [Bool]( repeating: false, count: 6 )
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.prayerTimestableView.reloadData()
            self.getNextPrayerTime()
            
            let isLaunchBefore = UserDefaults.standard.value(forKey: UserDefaultsConstants.isLaunchedBefore) as! Bool
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd"
            let day = dateFormatter.string(from: date)
            dateFormatter.dateFormat = "MM"
            let month = dateFormatter.string(from: date)
//            if(!isLaunchBefore || ( day == "01" && month == "01" )){
//            UserDefaults.standard.set(true, forKey: "isLaunchedBefore")
            self.presenter.saveDataToRealm()
//                 }
 
        }
        
    }
    func showIndicator() {
        self.view.addSubview(activityIndicator)
        activityIndicator.center = self.view.center
        activityIndicator.startAnimating()
    }
      
    func imoprtToCalendarsSuccess() {
        Helper.showToast(message: "Home.exportedSuccessfullyToasterMessage".localized)
        activityIndicator.stopAnimating()
      }
      
}
/// This is a class created for conform to settingsVCView to recall the API if there is any change at settings Parameters
extension HomeViewController:settingsVCView{
    func APIParameterChanged() {
        presenter.requestPrayerTimesAPI()
//        self.presenter.saveDataToRealm()
    }
    
}
