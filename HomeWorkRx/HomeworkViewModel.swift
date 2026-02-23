//
//  HomeworkViewModel.swift
//  HomeWorkRx
//
//  Created by 김기태 on 2/23/26.
//

import Foundation
import RxSwift
import RxCocoa

final class HomeworkViewModel {
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let viewDidLoad = PublishSubject<Void>()
        let tableViewTapped = PublishSubject<SampleUser>()
        let collectionViewTapped = PublishSubject<SampleUser>()
    }
    struct Output {
        let users: BehaviorSubject<[SampleUser]>
        let selectedUsers: Observable<[SampleUser]>
    }
    
    func transform(input: Input) -> Output {
        let users = makeUserList(event: input.viewDidLoad)
        let selectedUsers = makeSelectedUserList(event: input.tableViewTapped)
        
        input.collectionViewTapped
            .withLatestFrom(users) { tappedUser, currentUsers in
                var newList = currentUsers
                newList.append(tappedUser)
                return newList
            }
            .bind(to: users)
            .disposed(by: disposeBag)
        
        return Output(users: users, selectedUsers: selectedUsers)
    }
    
    func makeUserList(event: PublishSubject<Void>) -> BehaviorSubject<[SampleUser]> {
        let userSubject = BehaviorSubject<[SampleUser]>(value: dummyUsers)
        
        event
            .map { _ in dummyUsers }
            .bind(to: userSubject)
            .disposed(by: disposeBag)
        
        return userSubject
    }
    
    func makeSelectedUserList(event: PublishSubject<SampleUser>) -> Observable<[SampleUser]> {
        return event
            .scan(into: [SampleUser]()) { array, user in
                array.append(user)
            }
    }
    
    
    
}
