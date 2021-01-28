//
//  DefaultWallet+Promises.swift
//  ZKSyncSDK
//
//  Created by Eugene Belyakov on 16/01/2021.
//

import Foundation
import PromiseKit
import BigInt

extension DefaultWallet {
    
    func getNonce() -> Promise<UInt32> {
        return Promise { getNonce(completion: $0.resolve )}
    }
    
    func getTokens() -> Promise<Tokens> {
        return Promise { provider.tokens(completion: $0.resolve ) }
    }
    
    func submitSignedTransaction<TX: ZkSyncTransaction>(_ transaction: TX,
                                                        ethereumSignature: EthSignature?,
                                                        fastProcessing: Bool) -> Promise<String> {
        return Promise { provider.submitTx(transaction,
                                           ethereumSignature: ethereumSignature,
                                           fastProcessing: fastProcessing,
                                           completion: $0.resolve )
        }
    }
}

extension Swift.Result {
    var promiseResult: PromiseKit.Result<Success> {
        switch self {
        case .success(let success):
            return .fulfilled(success)
        case .failure(let error):
            return .rejected(error)
        }
    }
}

public extension PromiseKit.Resolver {
    func resolve(_ result: Swift.Result<T, Error>) {
        self.resolve(result.promiseResult)
    }
}

public extension PromiseKit.Result {
    var result: Swift.Result<T, Error> {
        switch self {
        case .fulfilled(let value):
            return .success(value)
        case .rejected(let error):
            return .failure(error)
        }
    }
}
