//
//  ViewController.swift
//  JSONBlobiOS
//
//  Created by ishant on 24/06/16.
//  Copyright © 2016 ishant. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper


class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,NoInternetDelegate {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    var expenseList = [Expense]()
    var timer: NSTimer?
    var expenseResponse: ExpenseListResponse?
    static let getExpenseListNotifier = "expenseListNotifier"
    let rupee = "\u{20B9}"

    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ViewController.refreshExpenseList(_:)), forControlEvents: UIControlEvents.ValueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.addSubview(refreshControl)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.onTimerSuccess(_:)), name: ViewController.getExpenseListNotifier, object: nil)
        self.navigationItem.title = "Expenses"
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func refreshExpenseList(refreshControl: UIRefreshControl) {
        self.getExpenseList()
    }
    
    //ns notification success
    func onTimerSuccess(noti: NSNotification){
        self.getExpenseList()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.getExpenseList()
    }
    
    
    private func startActivityIndicator() {
        self.activityIndicator.startAnimating()
        self.activityIndicator.hidden = false
    }
    
    private func stopActivityIndicator() {
        self.activityIndicator.stopAnimating()
        self.activityIndicator.hidden = true
        if self.refreshControl.refreshing {
            self.refreshControl.endRefreshing()
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.expenseList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("ExpenseTableViewCell", forIndexPath: indexPath) as! ExpenseTableViewCell
        let row = self.expenseList[indexPath.row]
        cell.categoryLabel.text = row.category!
        cell.amountLabel.text = "\(rupee)\(Int(row.amount!))"
        cell.descriptionLabel.text = row.description!
        let type = StateType.getStateType(row.state!)
        cell.stateLabel.text = type.rawValue
        var stateInButtonOne:StateType?
        var stateInButtonTwo:StateType?
        if type == StateType.VERIFIED{
            cell.buttonOne.setTitle("UNVERIFY", forState: UIControlState.Normal)
            cell.buttonOne.backgroundColor = UIColor.blueColor()
            cell.buttonTwo.setTitle("FRAUD", forState: UIControlState.Normal)
            cell.buttonTwo.backgroundColor = UIColor.grayColor()
            stateInButtonOne = StateType.UNVERIFIED
            stateInButtonTwo = StateType.FRAUDUANT
        }else if type == StateType.UNVERIFIED{
            cell.buttonOne.setTitle("VERIFY", forState: UIControlState.Normal)
            cell.buttonOne.backgroundColor = UIColor.greenColor()
            cell.buttonTwo.setTitle("FRAUD", forState: UIControlState.Normal)
            cell.buttonTwo.backgroundColor = UIColor.grayColor()
            stateInButtonOne = StateType.VERIFIED
            stateInButtonTwo = StateType.FRAUDUANT
        }else{
            cell.buttonOne.setTitle("VERIFY", forState: UIControlState.Normal)
            cell.buttonOne.backgroundColor = UIColor.greenColor()
            cell.buttonTwo.setTitle("UNVERIFY", forState: UIControlState.Normal)
            cell.buttonTwo.backgroundColor = UIColor.blueColor()
            stateInButtonOne = StateType.VERIFIED
            stateInButtonTwo = StateType.UNVERIFIED
        }
        cell.onButtonOneTapped = {
            self.postExpenseState(indexPath.row, state: stateInButtonOne!.rawValue, expense: row)
        }
        cell.onButtonTwoTapped = {
            self.postExpenseState(indexPath.row, state: stateInButtonTwo!.rawValue, expense: row)
        }
        return cell
    }
    
    // for dynamic height
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        self.tableView.estimatedRowHeight = 164.0
        return UITableViewAutomaticDimension
    }


    func getExpenseList(){
        if expenseList.count == 0 {
            self.startActivityIndicator()
        }
        AlamofireUtils.makeUnAuthorisedRequest(.GET, URI: URIConstants.GET_EXPENSE, parameters: nil) {
            (response: ExpenseListResponse?, error,isInternetConnected) -> Void
            in
            if self.activityIndicator.isAnimating(){
                self.stopActivityIndicator()
            }
            if self.refreshControl.refreshing{
                self.refreshControl.endRefreshing()
            }
            if response != nil{
                if let responseUnwrap = response{
                    self.expenseResponse = responseUnwrap
                    self.expenseList = responseUnwrap.expenseList!
                    self.tableView.reloadData()
                }
            }else if !isInternetConnected{
                if self.expenseList.count == 0{
                    self.presentNoInternetConnection()
                }else{
                    if let errorString = error{
                        self.showToast(errorString)
                    }
                }
            }
        }
    }
    
    func postExpenseState(position: Int,state: String,expense: Expense){
        let indicator = ActivityViewController(message: state)
        self.presentViewController(indicator, animated: false, completion: nil)
        let newResponse = expenseResponse
        expense.state = state
        var list = expenseList
        list.removeAtIndex(position)
        list.insert(expense, atIndex: position)
        newResponse?.expenseList = list
        let params = Mapper().toJSON(newResponse!)
        AlamofireUtils.makeUnAuthorisedRequest(.POST, URI: URIConstants.GET_EXPENSE, parameters: params) { (response: ExpenseListResponse?, error,isInternetConnected) in
            
            indicator.dismissViewControllerAnimated(false, completion: nil)
            if response != nil{
                if let responseUnwrap = response{
                    self.expenseResponse = responseUnwrap
                    self.expenseList = responseUnwrap.expenseList!
                    self.tableView.reloadData()
                }
            }else if !isInternetConnected{
                if self.expenseList.count == 0{
                    self.presentNoInternetConnection()
                }else{
                    if let errorString = error{
                        self.showToast(errorString)
                    }
                }
            }
        }
    }
    
    func presentNoInternetConnection(){
        if let vc = self.storyboard?.instantiateViewControllerWithIdentifier("NoInternetViewController") as? NoInternetViewController{
            vc.noInternetDelegate = self
            self.presentViewController(vc, animated: false, completion: nil)
        }
    }
    
    func connectedToInternet() {
        self.getExpenseList()
    }
    
    func showToast(toastMessage: String) {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        self.view.makeToast(toastMessage, position: CGPoint(x: screenSize.width/2, y: (screenSize.height - 50.0)))
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

