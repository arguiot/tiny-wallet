// ∅ 2024 lil org

import Foundation
import BigInt

struct DirectTransactionRequest: Codable {
    let requestId: Int
    let to: String
    let from: String
    let data: String
    let value: String
    let gas: String
    let gasPrice: String
    let id: String
    let outputToken: String
    let inputToken: String
    let inputTicker: String
    let outputTicker: String
    let inputAmount: String
    let outputAmount: String
    let chainId: String
    let signature: String
}

extension DirectTransactionRequest {
    
    init?(from urlString: String) {
        guard let url = URL(string: urlString),
              let host = url.host, ["yo.finance"].contains(host),
              let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems,
              let query = url.query,
              let range = query.range(of: "&signature=") else {
            return nil
        }
        
        let input = String(query[..<range.lowerBound])
        let signature = String(query[range.upperBound...])
        guard Ethereum.shared.validateYoFinance(input: input, signature: signature) else { return nil }
        var parameters = queryItems.reduce(into: [String: Any]()) { (result, item) in
            result[item.name] = item.value ?? ""
        }
        
        parameters["requestId"] = Int.random(in: 1..<Int.max)
        
        do {
            let data = try JSONSerialization.data(withJSONObject: parameters, options: [])
            self = try JSONDecoder().decode(DirectTransactionRequest.self, from: data)
        } catch { return nil }
    }
    
    func createTransaction() -> Transaction {
        let hexValue = String.hex(BigInt(stringLiteral: value))
        let transaction = Transaction(id: UUID(),
                                      from: from,
                                      to: to,
                                      nonce: nil,
                                      gasPrice: gasPrice,
                                      gas: gas,
                                      value: hexValue,
                                      data: data,
                                      interpretation: nil,
                                      externalInterpretation: "\(Strings.swap) \(inputAmount) \(inputTicker) <> \(outputAmount) \(outputTicker)")
        return transaction
    }
    
}
