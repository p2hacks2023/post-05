//
//  ViewModel.swift
//  P2hacks
//
//  Created by 山本拓摩 on 2023/12/10.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import CryptoKit
import GoogleSignIn
import GoogleSignInSwift
import FirebaseStorage

class ViewModel: ObservableObject {
    
    @Published var users = [UserInfo]()
    //@Published var mydata = MyData()
    @Published var userSignedIn: Bool = false
    @Published var path = NavigationPath()
    let auth = Auth.auth()
    @Published var isPresentAlert = false
    @Published var customAlertInfo = CustomAlertInfo(title: "", description: "")
    let db = Firestore.firestore()
    @Published var isGoogleProvider = false
    let storage = Storage.storage()
    var userList: Array<UserInfo> = []
    
    @State var downloadedImage: UIImage?
    // イニシャライザメソッドを呼び出して、アプリの起動時に認証状態をチェックする
    init() {
        observeAuthChanges()
        
        //データベースからユーザのデータ一覧を取得（読み取り回数削減のため）
        fetchFirestoreData { (users, error) in
            if let error = error {
                print("Error fetching Firestore data: \(error)")
                return
            }
            
            if let users = users {
                self.userList = users
            }
        }
    }
    
    //mydataの取得
    func MyData() -> UserInfo{
        var mydata : UserInfo
        
    }

    private func observeAuthChanges() {
        auth.addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.userSignedIn = user != nil
            }
        }
    }
    
    func getUserID() -> String{
        let currentUserUID = auth.currentUser?.uid ?? ""
        return currentUserUID
    }
    
    func fetchFirestoreData(completion: @escaping ([UserInfo]?, Error?) -> Void) {
        let db = Firestore.firestore()
        let collection = db.collection("users")

        collection.getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(nil, error)
                return
            }

            guard let documents = querySnapshot?.documents else {
                completion(nil, nil)
                return
            }

            let users: [UserInfo] = documents.compactMap { document in
                do {
                    let userInfo = try document.data(as: UserInfo.self)
                    return userInfo
                } catch {
                    print("Error decoding document: \(error)")
                    return nil
                }
            }

            completion(users, nil)
        }
    }

    /*
    func fetchFireStore() async throws {
        db.collection("users").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.users = documents.map { (queryDocumentSnapshot) -> UserInfo in
                let data = queryDocumentSnapshot.data()
                let id = data["id"] as? String ?? ""
                let name = data["name"] as? String ?? ""
                let age = data["age"] as? Int ?? 0
                let job = data["job"] as? String ?? ""
                let weight = data["weight"] as? Int ?? 0
                let change = data["change"] as? Int ?? 0
                let icon = data["icon"] as? String ?? ""
                let friends = data["friends"] as? Array<String> ?? []
                
                return UserInfo(id: id, name: name, age: age, job: job, weight: weight, change: change, icon: icon, friends: friends)
            }
        }
    }
     */
    
    func writeFireStore(data: UserInfo){
        let collection = Firestore.firestore().collection("users")
        collection.document(data.id).setData(data.dictionary) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        
    }
    
    func addFriend(friendID: String, mydata: UserInfo){
        for user in userList {
            if user.id == friendID {
                add
                return
            }
        }
    }
    
    //画像をアップロードする関数
    func uploadImage(file : String){
        let storageref = storage.reference(forURL: "gs://p2hacks-c83b9.appspot.com").child(file)
        
        let image = UIImage(named: file)
        
        if let image = image {
            if let data = image.pngData() as NSData? {
                storageref.putData(data as Data, metadata: nil) { (data, error) in
                    if let error = error {
                        print("Error uploading image: (error.localizedDescription)")
                    } else {
                        print("Image uploaded successfully!")
                    }
                }
            }
        }
    }
    
    //画像をダウンロードする関数
    func downloadImage(file: String, completion: @escaping (UIImage?) -> Void) {
        
        let storageref = storage.reference(forURL: "gs://p2hacks-c83b9.appspot.com").child(file)
            
            // 最大ダウンロードサイズを設定する
            let maxDownloadSize: Int64 = 5 * 1024 * 1024 // 5MB
            
            storageref.getData(maxSize: maxDownloadSize) { data, error in
                if let error = error {
                    // エラーハンドリング
                    print("Error downloading image: \(error.localizedDescription)")
                    completion(nil)
                } else {
                    if let data = data, let downloadedImage = UIImage(data: data) {
                        // アプリ内に画像を保存する場合
                        self.saveImageToDocumentDirectory(image: downloadedImage)
                        
                        // 成功時に画像を返す
                        completion(downloadedImage)
                    } else {
                        // ダウンロードしたデータが正常な画像データでない場合のエラーハンドリング
                        print("Error: Downloaded data is not a valid image.")
                        completion(nil)
                    }
                }
            }
        
    }
    
    
    //画像をアプリ内に保存
    private func saveImageToDocumentDirectory(image: UIImage) {
        if let data = image.pngData(),
           let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentsDirectory.appendingPathComponent("downloaded_image.png")
            do {
                try data.write(to: fileURL)
                print("Image saved to: \(fileURL.absoluteString)")
            } catch {
                print("Error saving image: \(error.localizedDescription)")
            }
        }
    }

    
    func upDate(){
        
    }
    
    // ログインするメソッド
    func signIn(email: String, password: String) {
            auth.signIn(withEmail: email, password: password) { [weak self] result, error in
                DispatchQueue.main.async {
                    if result != nil, error == nil {
                        self?.userSignedIn = true
                    }
                }
            }
        }
    // 新規登録するメソッド
    func signUp(email: String, password: String) {
        auth.createUser(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                if result != nil, error == nil {
                    self?.userSignedIn = true
                }
            }
        }
    }
    
    func isUserSignedIn(){
        let result = auth.currentUser != nil
        DispatchQueue.main.async {
            [weak self] in
            self?.userSignedIn = result
        }
    }
    
    func backToRootScreen() {
        DispatchQueue.main.async {
            [weak self] in
            self?.path = .init()
        }
    }
    
    func showAlertWith(title: String, description: String) {
        DispatchQueue.main.async {
            [weak self] in
            self?.customAlertInfo.title = title
            self?.customAlertInfo.description = description
            self?.isPresentAlert = true
        }
    }
    
    // SignIn with Google
    func googleSignIn(){
        
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            GIDSignIn.sharedInstance.restorePreviousSignIn(){
                [unowned self] user, error in
                authenticateGoogleUser(for: user, with: error)
                
            }
        } else {
            
            
            guard let windowsScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            guard let rootViewController = windowsScene.windows.first?.rootViewController else { return }
            guard let clientID = FirebaseApp.app()?.options.clientID else { return }
            
            let config = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.configuration = config
            GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [unowned self] result, error in
                guard let user = result?.user else {
                    print("Don't have a user")
                    return
                }
                
                authenticateGoogleUser(for: user, with: error)
            }
            
            
        }
    }
    
    func authenticateGoogleUser(for user: GIDGoogleUser?, with error: Error?) {
        guard  error == nil else {
            print("Error with authenticateGoogleUser \(String(describing: error))")
            showAlertWith(title: "Error: Google Notification", description: "Error: \(String(describing: error))")
            return
        }
        
        guard let idToken = user?.idToken else {
            return
        }
        guard let accessToken = user?.accessToken else {
            return
        }
        
        let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken:  accessToken.tokenString)
        
        auth.signIn(with: credential) {
            [weak self] (_, error) in
            guard error == nil else {
                self?.showAlertWith(title: "SignIn with Google Error", description: "Error: \(String(describing: error))")
                return
            }
            
            self?.isUserSignedIn()
            self?.backToRootScreen()
            
        }
    }
    
    func signOut() {
        do {
            try auth.signOut()
            userSignedIn = false
        }
        catch {
            showAlertWith(title: "Error with signOut", description: "Error: \(error)")
        }
    }

}

//@ServerTimestamp var lastUpdated: Timestamp?
struct CustomAlertInfo {
    var title: String
    var description: String
}
