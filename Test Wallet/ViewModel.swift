//
//  ViewModel.swift
//  Test Wallet
//
//  Created by RBLabs RD - Shane on 2023/3/21.
//

import Foundation
import Web3
import Web3Wallet

func myPrint(_ items: Any...) {
    print(":::", items)
}

let RPC_URL  = "https://dev-ganache.pomo.network/"
let RPC_PORT = "9527"

let CONTRACT_ADDRESS = "0x09430eF1032bBB52c4F60BC00Bb0AaC1dfEd3972"

let MY_PRIVATE_KEY = "0x7742f00f27407887563707673c4c0afaab1c87fbe6cabf5547aeb58fe2260cdd"

let ETHERSCAN_API_KEY = "QNCD24AX3PTV5B3KMUP5FN95WE1JWZCIBS"
let OPENSEA_API_KEY = "c823fdee93814f7abd5492604697e9c8"

enum Chain: Int {
    case Ethereum = 1
    case Ethereum_Goerli = 5
    case PomoChain = 1337
    
    var eip155: String {
        return "eip155:\(self.rawValue)"
    }
    
    var chainId: Int {
        return self.rawValue
    }
    
    var blockchain: Blockchain {
        Blockchain(self.eip155)!
    }
}

extension Int {
    var ethQty: EthereumQuantity {
        return EthereumQuantity(quantity: BigUInt(self))
    }
}

let ABI = """
{
    "_format": "hh-sol-artifact-1",
    "contractName": "PomoNetwork",
    "sourceName": "contracts/PomoNetwork.sol",
    "abi": [
      {
        "inputs": [],
        "stateMutability": "nonpayable",
        "type": "constructor"
      },
      {
        "inputs": [],
        "name": "ApprovalCallerNotOwnerNorApproved",
        "type": "error"
      },
      {
        "inputs": [],
        "name": "ApprovalQueryForNonexistentToken",
        "type": "error"
      },
      {
        "inputs": [],
        "name": "BalanceQueryForZeroAddress",
        "type": "error"
      },
      {
        "inputs": [],
        "name": "InvalidQueryRange",
        "type": "error"
      },
      {
        "inputs": [],
        "name": "InvalidToken",
        "type": "error"
      },
      {
        "inputs": [],
        "name": "MintERC2309QuantityExceedsLimit",
        "type": "error"
      },
      {
        "inputs": [],
        "name": "MintToZeroAddress",
        "type": "error"
      },
      {
        "inputs": [],
        "name": "MintZeroQuantity",
        "type": "error"
      },
      {
        "inputs": [],
        "name": "NotAuthorized",
        "type": "error"
      },
      {
        "inputs": [],
        "name": "OwnerQueryForNonexistentToken",
        "type": "error"
      },
      {
        "inputs": [],
        "name": "OwnershipNotInitializedForExtraData",
        "type": "error"
      },
      {
        "inputs": [],
        "name": "TransferCallerNotOwnerNorApproved",
        "type": "error"
      },
      {
        "inputs": [],
        "name": "TransferFromIncorrectOwner",
        "type": "error"
      },
      {
        "inputs": [],
        "name": "TransferToNonERC721ReceiverImplementer",
        "type": "error"
      },
      {
        "inputs": [],
        "name": "TransferToZeroAddress",
        "type": "error"
      },
      {
        "inputs": [],
        "name": "URIQueryForNonexistentToken",
        "type": "error"
      },
      {
        "anonymous": false,
        "inputs": [
          {
            "indexed": true,
            "internalType": "address",
            "name": "owner",
            "type": "address"
          },
          {
            "indexed": true,
            "internalType": "address",
            "name": "approved",
            "type": "address"
          },
          {
            "indexed": true,
            "internalType": "uint256",
            "name": "tokenId",
            "type": "uint256"
          }
        ],
        "name": "Approval",
        "type": "event"
      },
      {
        "anonymous": false,
        "inputs": [
          {
            "indexed": true,
            "internalType": "address",
            "name": "owner",
            "type": "address"
          },
          {
            "indexed": true,
            "internalType": "address",
            "name": "operator",
            "type": "address"
          },
          {
            "indexed": false,
            "internalType": "bool",
            "name": "approved",
            "type": "bool"
          }
        ],
        "name": "ApprovalForAll",
        "type": "event"
      },
      {
        "anonymous": false,
        "inputs": [
          {
            "indexed": true,
            "internalType": "uint256",
            "name": "fromTokenId",
            "type": "uint256"
          },
          {
            "indexed": false,
            "internalType": "uint256",
            "name": "toTokenId",
            "type": "uint256"
          },
          {
            "indexed": true,
            "internalType": "address",
            "name": "from",
            "type": "address"
          },
          {
            "indexed": true,
            "internalType": "address",
            "name": "to",
            "type": "address"
          }
        ],
        "name": "ConsecutiveTransfer",
        "type": "event"
      },
      {
        "anonymous": false,
        "inputs": [
          {
            "indexed": true,
            "internalType": "address",
            "name": "previousOwner",
            "type": "address"
          },
          {
            "indexed": true,
            "internalType": "address",
            "name": "newOwner",
            "type": "address"
          }
        ],
        "name": "OwnershipTransferred",
        "type": "event"
      },
      {
        "anonymous": false,
        "inputs": [
          {
            "indexed": true,
            "internalType": "address",
            "name": "from",
            "type": "address"
          },
          {
            "indexed": true,
            "internalType": "address",
            "name": "to",
            "type": "address"
          },
          {
            "indexed": true,
            "internalType": "uint256",
            "name": "tokenId",
            "type": "uint256"
          }
        ],
        "name": "Transfer",
        "type": "event"
      },
      {
        "inputs": [
          {
            "internalType": "address",
            "name": "to",
            "type": "address"
          },
          {
            "internalType": "uint256",
            "name": "tokenId",
            "type": "uint256"
          }
        ],
        "name": "approve",
        "outputs": [],
        "stateMutability": "payable",
        "type": "function"
      },
      {
        "inputs": [
          {
            "internalType": "address",
            "name": "owner",
            "type": "address"
          }
        ],
        "name": "balanceOf",
        "outputs": [
          {
            "internalType": "uint256",
            "name": "",
            "type": "uint256"
          }
        ],
        "stateMutability": "view",
        "type": "function"
      },
      {
        "inputs": [
          {
            "internalType": "uint256",
            "name": "tokenId",
            "type": "uint256"
          }
        ],
        "name": "burn",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
      },
      {
        "inputs": [
          {
            "internalType": "uint256",
            "name": "tokenId",
            "type": "uint256"
          }
        ],
        "name": "explicitOwnershipOf",
        "outputs": [
          {
            "components": [
              {
                "internalType": "address",
                "name": "addr",
                "type": "address"
              },
              {
                "internalType": "uint64",
                "name": "startTimestamp",
                "type": "uint64"
              },
              {
                "internalType": "bool",
                "name": "burned",
                "type": "bool"
              },
              {
                "internalType": "uint24",
                "name": "extraData",
                "type": "uint24"
              }
            ],
            "internalType": "struct IERC721A.TokenOwnership",
            "name": "",
            "type": "tuple"
          }
        ],
        "stateMutability": "view",
        "type": "function"
      },
      {
        "inputs": [
          {
            "internalType": "uint256[]",
            "name": "tokenIds",
            "type": "uint256[]"
          }
        ],
        "name": "explicitOwnershipsOf",
        "outputs": [
          {
            "components": [
              {
                "internalType": "address",
                "name": "addr",
                "type": "address"
              },
              {
                "internalType": "uint64",
                "name": "startTimestamp",
                "type": "uint64"
              },
              {
                "internalType": "bool",
                "name": "burned",
                "type": "bool"
              },
              {
                "internalType": "uint24",
                "name": "extraData",
                "type": "uint24"
              }
            ],
            "internalType": "struct IERC721A.TokenOwnership[]",
            "name": "",
            "type": "tuple[]"
          }
        ],
        "stateMutability": "view",
        "type": "function"
      },
      {
        "inputs": [
          {
            "internalType": "uint256",
            "name": "tokenId",
            "type": "uint256"
          }
        ],
        "name": "getApproved",
        "outputs": [
          {
            "internalType": "address",
            "name": "",
            "type": "address"
          }
        ],
        "stateMutability": "view",
        "type": "function"
      },
      {
        "inputs": [],
        "name": "getMyAddress",
        "outputs": [
          {
            "internalType": "address",
            "name": "",
            "type": "address"
          }
        ],
        "stateMutability": "view",
        "type": "function"
      },
      {
        "inputs": [],
        "name": "getMyBalance",
        "outputs": [
          {
            "internalType": "uint256",
            "name": "",
            "type": "uint256"
          }
        ],
        "stateMutability": "view",
        "type": "function"
      },
      {
        "inputs": [
          {
            "internalType": "address",
            "name": "owner",
            "type": "address"
          },
          {
            "internalType": "address",
            "name": "operator",
            "type": "address"
          }
        ],
        "name": "isApprovedForAll",
        "outputs": [
          {
            "internalType": "bool",
            "name": "",
            "type": "bool"
          }
        ],
        "stateMutability": "view",
        "type": "function"
      },
      {
        "inputs": [
          {
            "internalType": "uint256",
            "name": "tokenId",
            "type": "uint256"
          }
        ],
        "name": "isTokenValid",
        "outputs": [
          {
            "internalType": "bool",
            "name": "",
            "type": "bool"
          }
        ],
        "stateMutability": "view",
        "type": "function"
      },
      {
        "inputs": [
          {
            "internalType": "address",
            "name": "to",
            "type": "address"
          },
          {
            "internalType": "uint256",
            "name": "quantity",
            "type": "uint256"
          }
        ],
        "name": "mint",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
      },
      {
        "inputs": [],
        "name": "name",
        "outputs": [
          {
            "internalType": "string",
            "name": "",
            "type": "string"
          }
        ],
        "stateMutability": "view",
        "type": "function"
      },
      {
        "inputs": [],
        "name": "nextTokenId",
        "outputs": [
          {
            "internalType": "uint256",
            "name": "",
            "type": "uint256"
          }
        ],
        "stateMutability": "view",
        "type": "function"
      },
      {
        "inputs": [
          {
            "internalType": "address",
            "name": "owner",
            "type": "address"
          }
        ],
        "name": "numBurnedOf",
        "outputs": [
          {
            "internalType": "uint256",
            "name": "",
            "type": "uint256"
          }
        ],
        "stateMutability": "view",
        "type": "function"
      },
      {
        "inputs": [
          {
            "internalType": "address",
            "name": "owner",
            "type": "address"
          }
        ],
        "name": "numMintedOf",
        "outputs": [
          {
            "internalType": "uint256",
            "name": "",
            "type": "uint256"
          }
        ],
        "stateMutability": "view",
        "type": "function"
      },
      {
        "inputs": [],
        "name": "owner",
        "outputs": [
          {
            "internalType": "address",
            "name": "",
            "type": "address"
          }
        ],
        "stateMutability": "view",
        "type": "function"
      },
      {
        "inputs": [
          {
            "internalType": "uint256",
            "name": "tokenId",
            "type": "uint256"
          }
        ],
        "name": "ownerOf",
        "outputs": [
          {
            "internalType": "address",
            "name": "",
            "type": "address"
          }
        ],
        "stateMutability": "view",
        "type": "function"
      },
      {
        "inputs": [],
        "name": "provenanceMerkleRoot",
        "outputs": [
          {
            "internalType": "bytes32",
            "name": "",
            "type": "bytes32"
          }
        ],
        "stateMutability": "view",
        "type": "function"
      },
      {
        "inputs": [],
        "name": "renounceOwnership",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
      },
      {
        "inputs": [
          {
            "internalType": "uint256",
            "name": "_tokenId",
            "type": "uint256"
          },
          {
            "internalType": "uint256",
            "name": "_salePrice",
            "type": "uint256"
          }
        ],
        "name": "royaltyInfo",
        "outputs": [
          {
            "internalType": "address",
            "name": "",
            "type": "address"
          },
          {
            "internalType": "uint256",
            "name": "",
            "type": "uint256"
          }
        ],
        "stateMutability": "view",
        "type": "function"
      },
      {
        "inputs": [
          {
            "internalType": "address",
            "name": "from",
            "type": "address"
          },
          {
            "internalType": "address",
            "name": "to",
            "type": "address"
          },
          {
            "internalType": "uint256",
            "name": "tokenId",
            "type": "uint256"
          }
        ],
        "name": "safeTransferFrom",
        "outputs": [],
        "stateMutability": "payable",
        "type": "function"
      },
      {
        "inputs": [
          {
            "internalType": "address",
            "name": "from",
            "type": "address"
          },
          {
            "internalType": "address",
            "name": "to",
            "type": "address"
          },
          {
            "internalType": "uint256",
            "name": "tokenId",
            "type": "uint256"
          },
          {
            "internalType": "bytes",
            "name": "_data",
            "type": "bytes"
          }
        ],
        "name": "safeTransferFrom",
        "outputs": [],
        "stateMutability": "payable",
        "type": "function"
      },
      {
        "inputs": [
          {
            "internalType": "address",
            "name": "operator",
            "type": "address"
          },
          {
            "internalType": "bool",
            "name": "approved",
            "type": "bool"
          }
        ],
        "name": "setApprovalForAll",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
      },
      {
        "inputs": [
          {
            "internalType": "address",
            "name": "addr",
            "type": "address"
          },
          {
            "internalType": "bool",
            "name": "isAuthorized",
            "type": "bool"
          }
        ],
        "name": "setAuthorized",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
      },
      {
        "inputs": [
          {
            "internalType": "string",
            "name": "baseTokenUri",
            "type": "string"
          }
        ],
        "name": "setBaseTokenUri",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
      },
      {
        "inputs": [
          {
            "internalType": "address",
            "name": "receiver",
            "type": "address"
          },
          {
            "internalType": "uint96",
            "name": "feeNumerator",
            "type": "uint96"
          }
        ],
        "name": "setDefaultRoyalty",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
      },
      {
        "inputs": [
          {
            "internalType": "bytes32",
            "name": "root",
            "type": "bytes32"
          }
        ],
        "name": "setProvenanceMerkleRoot",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
      },
      {
        "inputs": [
          {
            "internalType": "uint256",
            "name": "tokenId",
            "type": "uint256"
          }
        ],
        "name": "setTokenInvalid",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
      },
      {
        "inputs": [
          {
            "internalType": "uint256",
            "name": "tokenId",
            "type": "uint256"
          },
          {
            "internalType": "address",
            "name": "receiver",
            "type": "address"
          },
          {
            "internalType": "uint96",
            "name": "feeDenominator",
            "type": "uint96"
          }
        ],
        "name": "setTokenRoyalty",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
      },
      {
        "inputs": [
          {
            "internalType": "uint256",
            "name": "tokenId",
            "type": "uint256"
          }
        ],
        "name": "setTokenValid",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
      },
      {
        "inputs": [
          {
            "internalType": "bytes4",
            "name": "interfaceId",
            "type": "bytes4"
          }
        ],
        "name": "supportsInterface",
        "outputs": [
          {
            "internalType": "bool",
            "name": "",
            "type": "bool"
          }
        ],
        "stateMutability": "view",
        "type": "function"
      },
      {
        "inputs": [],
        "name": "symbol",
        "outputs": [
          {
            "internalType": "string",
            "name": "",
            "type": "string"
          }
        ],
        "stateMutability": "view",
        "type": "function"
      },
      {
        "inputs": [
          {
            "internalType": "uint256",
            "name": "tokenId",
            "type": "uint256"
          }
        ],
        "name": "tokenURI",
        "outputs": [
          {
            "internalType": "string",
            "name": "",
            "type": "string"
          }
        ],
        "stateMutability": "view",
        "type": "function"
      },
      {
        "inputs": [
          {
            "internalType": "address",
            "name": "owner",
            "type": "address"
          }
        ],
        "name": "tokensOfOwner",
        "outputs": [
          {
            "internalType": "uint256[]",
            "name": "",
            "type": "uint256[]"
          }
        ],
        "stateMutability": "view",
        "type": "function"
      },
      {
        "inputs": [
          {
            "internalType": "address",
            "name": "owner",
            "type": "address"
          },
          {
            "internalType": "uint256",
            "name": "start",
            "type": "uint256"
          },
          {
            "internalType": "uint256",
            "name": "stop",
            "type": "uint256"
          }
        ],
        "name": "tokensOfOwnerIn",
        "outputs": [
          {
            "internalType": "uint256[]",
            "name": "",
            "type": "uint256[]"
          }
        ],
        "stateMutability": "view",
        "type": "function"
      },
      {
        "inputs": [],
        "name": "totalSupply",
        "outputs": [
          {
            "internalType": "uint256",
            "name": "",
            "type": "uint256"
          }
        ],
        "stateMutability": "view",
        "type": "function"
      },
      {
        "inputs": [
          {
            "internalType": "address",
            "name": "from",
            "type": "address"
          },
          {
            "internalType": "address",
            "name": "to",
            "type": "address"
          },
          {
            "internalType": "uint256",
            "name": "tokenId",
            "type": "uint256"
          }
        ],
        "name": "transferFrom",
        "outputs": [],
        "stateMutability": "payable",
        "type": "function"
      },
      {
        "inputs": [
          {
            "internalType": "address",
            "name": "newOwner",
            "type": "address"
          }
        ],
        "name": "transferOwnership",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
      },
      {
        "inputs": [
          {
            "internalType": "uint256",
            "name": "metadataId",
            "type": "uint256"
          },
          {
            "internalType": "string",
            "name": "cid",
            "type": "string"
          },
          {
            "internalType": "bytes32[]",
            "name": "merkleProofs",
            "type": "bytes32[]"
          }
        ],
        "name": "verifyProvenance",
        "outputs": [
          {
            "internalType": "bool",
            "name": "",
            "type": "bool"
          }
        ],
        "stateMutability": "view",
        "type": "function"
      }
    ],
    "bytecode": "0x608060405260405180602001604052806000815250600b908162000024919062000625565b503480156200003257600080fd5b506040518060400160405280600c81526020017f504f4d4f204e6574776f726b00000000000000000000000000000000000000008152506040518060400160405280600481526020017f504f4d4f00000000000000000000000000000000000000000000000000000000815250620000bf620000b36200012960201b60201c565b6200013160201b60201c565b8160039081620000d0919062000625565b508060049081620000e2919062000625565b50620000f3620001f560201b60201c565b60018190555050506200012373f39fd6e51aad88f6f4ce6ab8827279cfffb922666103e8620001fe60201b60201c565b62000827565b600033905090565b60008060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff169050816000806101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff1602179055508173ffffffffffffffffffffffffffffffffffffffff168173ffffffffffffffffffffffffffffffffffffffff167f8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e060405160405180910390a35050565b60006001905090565b6200020e620003a160201b60201c565b6bffffffffffffffffffffffff16816bffffffffffffffffffffffff1611156200026f576040517f08c379a0000000000000000000000000000000000000000000000000000000008152600401620002669062000793565b60405180910390fd5b600073ffffffffffffffffffffffffffffffffffffffff168273ffffffffffffffffffffffffffffffffffffffff1603620002e1576040517f08c379a0000000000000000000000000000000000000000000000000000000008152600401620002d89062000805565b60405180910390fd5b60405180604001604052808373ffffffffffffffffffffffffffffffffffffffff168152602001826bffffffffffffffffffffffff16815250600960008201518160000160006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff16021790555060208201518160000160146101000a8154816bffffffffffffffffffffffff02191690836bffffffffffffffffffffffff1602179055509050505050565b6000612710905090565b600081519050919050565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052604160045260246000fd5b7f4e487b7100000000000000000000000000000000000000000000000000000000600052602260045260246000fd5b600060028204905060018216806200042d57607f821691505b602082108103620004435762000442620003e5565b5b50919050565b60008190508160005260206000209050919050565b60006020601f8301049050919050565b600082821b905092915050565b600060088302620004ad7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff826200046e565b620004b986836200046e565b95508019841693508086168417925050509392505050565b6000819050919050565b6000819050919050565b60006200050662000500620004fa84620004d1565b620004db565b620004d1565b9050919050565b6000819050919050565b6200052283620004e5565b6200053a62000531826200050d565b8484546200047b565b825550505050565b600090565b6200055162000542565b6200055e81848462000517565b505050565b5b8181101562000586576200057a60008262000547565b60018101905062000564565b5050565b601f821115620005d5576200059f8162000449565b620005aa846200045e565b81016020851015620005ba578190505b620005d2620005c9856200045e565b83018262000563565b50505b505050565b600082821c905092915050565b6000620005fa60001984600802620005da565b1980831691505092915050565b6000620006158383620005e7565b9150826002028217905092915050565b6200063082620003ab565b67ffffffffffffffff8111156200064c576200064b620003b6565b5b62000658825462000414565b620006658282856200058a565b600060209050601f8311600181146200069d576000841562000688578287015190505b62000694858262000607565b86555062000704565b601f198416620006ad8662000449565b60005b82811015620006d757848901518255600182019150602085019450602081019050620006b0565b86831015620006f75784890151620006f3601f891682620005e7565b8355505b6001600288020188555050505b505050505050565b600082825260208201905092915050565b7f455243323938313a20726f79616c7479206665652077696c6c2065786365656460008201527f2073616c65507269636500000000000000000000000000000000000000000000602082015250565b60006200077b602a836200070c565b915062000788826200071d565b604082019050919050565b60006020820190508181036000830152620007ae816200076c565b9050919050565b7f455243323938313a20696e76616c696420726563656976657200000000000000600082015250565b6000620007ed6019836200070c565b9150620007fa82620007b5565b602082019050919050565b600060208201905081810360008301526200082081620007de565b9050919050565b61465d80620008376000396000f3fe6080604052600436106102305760003560e01c806370a082311161012e578063a22cb465116100ab578063c92243d81161006f578063c92243d814610860578063cd837b061461089d578063e985e9c5146108c8578063f2fde38b14610905578063f8c75f5d1461092e57610230565b8063a22cb46514610764578063b2a94ec51461078d578063b88d4fde146107ca578063c23dc68f146107e6578063c87b56dd1461082357610230565b80638da5cb5b116100f25780638da5cb5b1461067d57806395652cfa146106a857806395d89b41146106d157806399a2557a146106fc5780639a1662991461073957610230565b806370a0823114610598578063711bf9b2146105d5578063715018a6146105fe57806375794a3c146106155780638462151c1461064057610230565b80633e4045cc116101bc5780634c738909116101805780634c7389091461048d5780635944c753146104b85780635bbb2177146104e15780636352211e1461051e57806364bd7a3a1461055b57610230565b80633e4045cc146103cd57806340c10f19146103f657806342842e0e1461041f57806342966c681461043b578063477f1d571461046457610230565b8063095ea7b311610203578063095ea7b31461030357806318160ddd1461031f57806323b872dd1461034a578063275ec991146103665780632a55205a1461038f57610230565b806301ffc9a71461023557806304634d8d1461027257806306fdde031461029b578063081812fc146102c6575b600080fd5b34801561024157600080fd5b5061025c6004803603810190610257919061312b565b61096b565b6040516102699190613173565b60405180910390f35b34801561027e57600080fd5b5061029960048036038101906102949190613230565b61098d565b005b3480156102a757600080fd5b506102b06109a3565b6040516102bd9190613300565b60405180910390f35b3480156102d257600080fd5b506102ed60048036038101906102e89190613358565b610a35565b6040516102fa9190613394565b60405180910390f35b61031d600480360381019061031891906133af565b610ab4565b005b34801561032b57600080fd5b50610334610bf8565b60405161034191906133fe565b60405180910390f35b610364600480360381019061035f9190613419565b610c0f565b005b34801561037257600080fd5b5061038d60048036038101906103889190613358565b610f31565b005b34801561039b57600080fd5b506103b660048036038101906103b1919061346c565b610fcb565b6040516103c49291906134ac565b60405180910390f35b3480156103d957600080fd5b506103f460048036038101906103ef919061350b565b6111b5565b005b34801561040257600080fd5b5061041d600480360381019061041891906133af565b6111c7565b005b61043960048036038101906104349190613419565b611258565b005b34801561044757600080fd5b50610462600480360381019061045d9190613358565b611278565b005b34801561047057600080fd5b5061048b60048036038101906104869190613358565b611286565b005b34801561049957600080fd5b506104a2611320565b6040516104af91906133fe565b60405180910390f35b3480156104c457600080fd5b506104df60048036038101906104da9190613538565b61133f565b005b3480156104ed57600080fd5b50610508600480360381019061050391906135f0565b611357565b60405161051591906137a0565b60405180910390f35b34801561052a57600080fd5b5061054560048036038101906105409190613358565b61141a565b6040516105529190613394565b60405180910390f35b34801561056757600080fd5b50610582600480360381019061057d91906137c2565b61142c565b60405161058f91906133fe565b60405180910390f35b3480156105a457600080fd5b506105bf60048036038101906105ba91906137c2565b61143e565b6040516105cc91906133fe565b60405180910390f35b3480156105e157600080fd5b506105fc60048036038101906105f7919061381b565b6114f6565b005b34801561060a57600080fd5b50610613611559565b005b34801561062157600080fd5b5061062a61156d565b60405161063791906133fe565b60405180910390f35b34801561064c57600080fd5b50610667600480360381019061066291906137c2565b61157c565b6040516106749190613919565b60405180910390f35b34801561068957600080fd5b506106926116bf565b60405161069f9190613394565b60405180910390f35b3480156106b457600080fd5b506106cf60048036038101906106ca9190613991565b6116e8565b005b3480156106dd57600080fd5b506106e6611706565b6040516106f39190613300565b60405180910390f35b34801561070857600080fd5b50610723600480360381019061071e91906139de565b611798565b6040516107309190613919565b60405180910390f35b34801561074557600080fd5b5061074e6119a4565b60405161075b9190613394565b60405180910390f35b34801561077057600080fd5b5061078b6004803603810190610786919061381b565b6119ac565b005b34801561079957600080fd5b506107b460048036038101906107af9190613a87565b611ab7565b6040516107c19190613173565b60405180910390f35b6107e460048036038101906107df9190613c4c565b611b41565b005b3480156107f257600080fd5b5061080d60048036038101906108089190613358565b611bb4565b60405161081a9190613d24565b60405180910390f35b34801561082f57600080fd5b5061084a60048036038101906108459190613358565b611c1e565b6040516108579190613300565b60405180910390f35b34801561086c57600080fd5b5061088760048036038101906108829190613358565b611cbc565b6040516108949190613173565b60405180910390f35b3480156108a957600080fd5b506108b2611cd9565b6040516108bf9190613d4e565b60405180910390f35b3480156108d457600080fd5b506108ef60048036038101906108ea9190613d69565b611cdf565b6040516108fc9190613173565b60405180910390f35b34801561091157600080fd5b5061092c600480360381019061092791906137c2565b611d73565b005b34801561093a57600080fd5b50610955600480360381019061095091906137c2565b611df6565b60405161096291906133fe565b60405180910390f35b600061097682611e08565b80610986575061098582611e82565b5b9050919050565b610995611f14565b61099f8282611f92565b5050565b6060600380546109b290613dd8565b80601f01602080910402602001604051908101604052809291908181526020018280546109de90613dd8565b8015610a2b5780601f10610a0057610100808354040283529160200191610a2b565b820191906000526020600020905b815481529060010190602001808311610a0e57829003601f168201915b5050505050905090565b6000610a4082612127565b610a76576040517fcf4700e400000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b6007600083815260200190815260200160002060000160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff169050919050565b6000610abf8261141a565b90508073ffffffffffffffffffffffffffffffffffffffff16610ae0612186565b73ffffffffffffffffffffffffffffffffffffffff1614610b4357610b0c81610b07612186565b611cdf565b610b42576040517fcfb3b94200000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b5b826007600084815260200190815260200160002060000160006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff160217905550818373ffffffffffffffffffffffffffffffffffffffff168273ffffffffffffffffffffffffffffffffffffffff167f8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b92560405160405180910390a4505050565b6000610c0261218e565b6002546001540303905090565b6000610c1a82612197565b90508373ffffffffffffffffffffffffffffffffffffffff168173ffffffffffffffffffffffffffffffffffffffff1614610c81576040517fa114810000000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b600080610c8d84612263565b91509150610ca38187610c9e612186565b61228a565b610cef57610cb886610cb3612186565b611cdf565b610cee576040517f59c896be00000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b5b600073ffffffffffffffffffffffffffffffffffffffff168573ffffffffffffffffffffffffffffffffffffffff1603610d55576040517fea553b3400000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b610d6286868660016122ce565b8015610d6d57600082555b600660008773ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020600081546001900391905081905550600660008673ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000206000815460010191905081905550610e3b85610e178888876123b6565b7c0200000000000000000000000000000000000000000000000000000000176123de565b600560008681526020019081526020016000208190555060007c0200000000000000000000000000000000000000000000000000000000841603610ec15760006001850190506000600560008381526020019081526020016000205403610ebf576001548114610ebe578360056000838152602001908152602001600020819055505b5b505b838573ffffffffffffffffffffffffffffffffffffffff168773ffffffffffffffffffffffffffffffffffffffff167fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef60405160405180910390a4610f298686866001612409565b505050505050565b600d60003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060009054906101000a900460ff16610fb4576040517fea8e4eb500000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b610fc881600c61240f90919063ffffffff16565b50565b6000806000600a60008681526020019081526020016000206040518060400160405290816000820160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020016000820160149054906101000a90046bffffffffffffffffffffffff166bffffffffffffffffffffffff166bffffffffffffffffffffffff16815250509050600073ffffffffffffffffffffffffffffffffffffffff16816000015173ffffffffffffffffffffffffffffffffffffffff16036111605760096040518060400160405290816000820160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020016000820160149054906101000a90046bffffffffffffffffffffffff166bffffffffffffffffffffffff166bffffffffffffffffffffffff168152505090505b600061116a61244d565b6bffffffffffffffffffffffff1682602001516bffffffffffffffffffffffff16866111969190613e38565b6111a09190613ea9565b90508160000151819350935050509250929050565b6111bd611f14565b80600e8190555050565b600d60003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060009054906101000a900460ff1661124a576040517fea8e4eb500000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b6112548282612457565b5050565b61127383838360405180602001604052806000815250611b41565b505050565b611283816001612613565b50565b600d60003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060009054906101000a900460ff16611309576040517fea8e4eb500000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b61131d81600c61286590919063ffffffff16565b50565b60003373ffffffffffffffffffffffffffffffffffffffff1631905090565b611347611f14565b6113528383836128a4565b505050565b6060600083839050905060008167ffffffffffffffff81111561137d5761137c613b21565b5b6040519080825280602002602001820160405280156113b657816020015b6113a3613070565b81526020019060019003908161139b5790505b50905060005b82811461140e576113e58686838181106113d9576113d8613eda565b5b90506020020135611bb4565b8282815181106113f8576113f7613eda565b5b60200260200101819052508060010190506113bc565b50809250505092915050565b600061142582612197565b9050919050565b600061143782612a4b565b9050919050565b60008073ffffffffffffffffffffffffffffffffffffffff168273ffffffffffffffffffffffffffffffffffffffff16036114a5576040517f8f4eb60400000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b67ffffffffffffffff600660008473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002054169050919050565b6114fe611f14565b80600d60008473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060006101000a81548160ff0219169083151502179055505050565b611561611f14565b61156b6000612aa2565b565b6000611577612b66565b905090565b6060600080600061158c8561143e565b905060008167ffffffffffffffff8111156115aa576115a9613b21565b5b6040519080825280602002602001820160405280156115d85781602001602082028036833780820191505090505b5090506115e3613070565b60006115ed61218e565b90505b8386146116b15761160081612b70565b915081604001516116a657600073ffffffffffffffffffffffffffffffffffffffff16826000015173ffffffffffffffffffffffffffffffffffffffff161461164b57816000015194505b8773ffffffffffffffffffffffffffffffffffffffff168573ffffffffffffffffffffffffffffffffffffffff16036116a5578083878060010198508151811061169857611697613eda565b5b6020026020010181815250505b5b8060010190506115f0565b508195505050505050919050565b60008060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff16905090565b6116f0611f14565b8181600b91826117019291906140c0565b505050565b60606004805461171590613dd8565b80601f016020809104026020016040519081016040528092919081815260200182805461174190613dd8565b801561178e5780601f106117635761010080835404028352916020019161178e565b820191906000526020600020905b81548152906001019060200180831161177157829003601f168201915b5050505050905090565b60608183106117d3576040517f32c1995a00000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b6000806117de612b66565b90506117e861218e565b8510156117fa576117f761218e565b94505b80841115611806578093505b60006118118761143e565b90508486101561183457600086860390508181101561182e578091505b50611839565b600090505b60008167ffffffffffffffff81111561185557611854613b21565b5b6040519080825280602002602001820160405280156118835781602001602082028036833780820191505090505b5090506000820361189a578094505050505061199d565b60006118a588611bb4565b9050600081604001516118ba57816000015190505b60008990505b8881141580156118d05750848714155b1561198f576118de81612b70565b9250826040015161198457600073ffffffffffffffffffffffffffffffffffffffff16836000015173ffffffffffffffffffffffffffffffffffffffff161461192957826000015191505b8a73ffffffffffffffffffffffffffffffffffffffff168273ffffffffffffffffffffffffffffffffffffffff1603611983578084888060010199508151811061197657611975613eda565b5b6020026020010181815250505b5b8060010190506118c0565b508583528296505050505050505b9392505050565b600033905090565b80600860006119b9612186565b73ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060008473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060006101000a81548160ff0219169083151502179055508173ffffffffffffffffffffffffffffffffffffffff16611a66612186565b73ffffffffffffffffffffffffffffffffffffffff167f17307eab39ab6107e8899845ad3d59bd9653f200f220920489ca2b5937696c3183604051611aab9190613173565b60405180910390a35050565b600080868686604051602001611acf939291906141e1565b604051602081830303815290604052805190602001209050611b35848480806020026020016040519081016040528093929190818152602001838360200280828437600081840152601f19601f82011690508083019250505050505050600e5483612b9b565b91505095945050505050565b611b4c848484610c0f565b60008373ffffffffffffffffffffffffffffffffffffffff163b14611bae57611b7784848484612bb2565b611bad576040517fd1a57ed600000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b5b50505050565b611bbc613070565b611bc4613070565b611bcc61218e565b831080611be05750611bdc612b66565b8310155b15611bee5780915050611c19565b611bf783612b70565b9050806040015115611c0c5780915050611c19565b611c1583612d02565b9150505b919050565b6060611c2982612127565b611c5f576040517fa14c4b5000000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b6000611c69612d22565b90506000815103611c895760405180602001604052806000815250611cb4565b80611c9384612db4565b604051602001611ca492919061423c565b6040516020818303038152906040525b915050919050565b6000611cd282600c612e0490919063ffffffff16565b9050919050565b600e5481565b6000600860008473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060008373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060009054906101000a900460ff16905092915050565b611d7b611f14565b600073ffffffffffffffffffffffffffffffffffffffff168173ffffffffffffffffffffffffffffffffffffffff1603611dea576040517f08c379a0000000000000000000000000000000000000000000000000000000008152600401611de1906142d2565b60405180910390fd5b611df381612aa2565b50565b6000611e0182612e40565b9050919050565b60007f2a55205a000000000000000000000000000000000000000000000000000000007bffffffffffffffffffffffffffffffffffffffffffffffffffffffff1916827bffffffffffffffffffffffffffffffffffffffffffffffffffffffff19161480611e7b5750611e7a82612e97565b5b9050919050565b60006301ffc9a760e01b827bffffffffffffffffffffffffffffffffffffffffffffffffffffffff19161480611edd57506380ac58cd60e01b827bffffffffffffffffffffffffffffffffffffffffffffffffffffffff1916145b80611f0d5750635b5e139f60e01b827bffffffffffffffffffffffffffffffffffffffffffffffffffffffff1916145b9050919050565b611f1c612f01565b73ffffffffffffffffffffffffffffffffffffffff16611f3a6116bf565b73ffffffffffffffffffffffffffffffffffffffff1614611f90576040517f08c379a0000000000000000000000000000000000000000000000000000000008152600401611f879061433e565b60405180910390fd5b565b611f9a61244d565b6bffffffffffffffffffffffff16816bffffffffffffffffffffffff161115611ff8576040517f08c379a0000000000000000000000000000000000000000000000000000000008152600401611fef906143d0565b60405180910390fd5b600073ffffffffffffffffffffffffffffffffffffffff168273ffffffffffffffffffffffffffffffffffffffff1603612067576040517f08c379a000000000000000000000000000000000000000000000000000000000815260040161205e9061443c565b60405180910390fd5b60405180604001604052808373ffffffffffffffffffffffffffffffffffffffff168152602001826bffffffffffffffffffffffff16815250600960008201518160000160006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff16021790555060208201518160000160146101000a8154816bffffffffffffffffffffffff02191690836bffffffffffffffffffffffff1602179055509050505050565b60008161213261218e565b11158015612141575060015482105b801561217f575060007c0100000000000000000000000000000000000000000000000000000000600560008581526020019081526020016000205416145b9050919050565b600033905090565b60006001905090565b600080829050806121a661218e565b1161222c5760015481101561222b5760006005600083815260200190815260200160002054905060007c0100000000000000000000000000000000000000000000000000000000821603612229575b6000810361221f5760056000836001900393508381526020019081526020016000205490506121f5565b809250505061225e565b505b5b6040517fdf2d9b4200000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b919050565b60008060006007600085815260200190815260200160002090508092508254915050915091565b600073ffffffffffffffffffffffffffffffffffffffff8316925073ffffffffffffffffffffffffffffffffffffffff821691508382148383141790509392505050565b600073ffffffffffffffffffffffffffffffffffffffff168473ffffffffffffffffffffffffffffffffffffffff1614806123355750600073ffffffffffffffffffffffffffffffffffffffff168373ffffffffffffffffffffffffffffffffffffffff16145b6123b05760008290505b818361234b919061445c565b8110156123ae5761236681600c612e0490919063ffffffff16565b1561239d576040517fc1ab6dc100000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b806123a790614490565b905061233f565b505b50505050565b60008060e883901c905060e86123cd868684612f09565b62ffffff16901b9150509392505050565b600073ffffffffffffffffffffffffffffffffffffffff83169250814260a01b178317905092915050565b50505050565b6000600882901c9050600060ff83166001901b9050808460000160008481526020019081526020016000206000828254179250508190555050505050565b6000612710905090565b6000600154905060008203612498576040517fb562e8dd00000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b6124a560008483856122ce565b600160406001901b178202600660008573ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000206000828254019250508190555061251c8361250d60008660006123b6565b61251685612f12565b176123de565b6005600083815260200190815260200160002081905550600080838301905073ffffffffffffffffffffffffffffffffffffffff85169150828260007fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef600080a4600183015b8181146125bd57808360007fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef600080a4600181019050612582565b50600082036125f8576040517f2e07630000000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b80600181905550505061260e6000848385612409565b505050565b600061261e83612197565b9050600081905060008061263186612263565b91509150841561269a5761264d8184612648612186565b61228a565b612699576126628361265d612186565b611cdf565b612698576040517f59c896be00000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b5b5b6126a88360008860016122ce565b80156126b357600082555b600160806001901b03600660008573ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000206000828254019250508190555061275b83612718856000886123b6565b7c02000000000000000000000000000000000000000000000000000000007c010000000000000000000000000000000000000000000000000000000017176123de565b600560008881526020019081526020016000208190555060007c02000000000000000000000000000000000000000000000000000000008516036127e157600060018701905060006005600083815260200190815260200160002054036127df5760015481146127de578460056000838152602001908152602001600020819055505b5b505b85600073ffffffffffffffffffffffffffffffffffffffff168473ffffffffffffffffffffffffffffffffffffffff167fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef60405160405180910390a461284b836000886001612409565b600260008154809291906001019190505550505050505050565b6000600882901c9050600060ff83166001901b905080198460000160008481526020019081526020016000206000828254169250508190555050505050565b6128ac61244d565b6bffffffffffffffffffffffff16816bffffffffffffffffffffffff16111561290a576040517f08c379a0000000000000000000000000000000000000000000000000000000008152600401612901906143d0565b60405180910390fd5b600073ffffffffffffffffffffffffffffffffffffffff168273ffffffffffffffffffffffffffffffffffffffff1603612979576040517f08c379a000000000000000000000000000000000000000000000000000000000815260040161297090614524565b60405180910390fd5b60405180604001604052808373ffffffffffffffffffffffffffffffffffffffff168152602001826bffffffffffffffffffffffff16815250600a600085815260200190815260200160002060008201518160000160006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff16021790555060208201518160000160146101000a8154816bffffffffffffffffffffffff02191690836bffffffffffffffffffffffff160217905550905050505050565b600067ffffffffffffffff6080600660008573ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002054901c169050919050565b60008060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff169050816000806101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff1602179055508173ffffffffffffffffffffffffffffffffffffffff168173ffffffffffffffffffffffffffffffffffffffff167f8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e060405160405180910390a35050565b6000600154905090565b612b78613070565b612b946005600084815260200190815260200160002054612f22565b9050919050565b600082612ba88584612fd8565b1490509392505050565b60008373ffffffffffffffffffffffffffffffffffffffff1663150b7a02612bd8612186565b8786866040518563ffffffff1660e01b8152600401612bfa9493929190614599565b6020604051808303816000875af1925050508015612c3657506040513d601f19601f82011682018060405250810190612c3391906145fa565b60015b612caf573d8060008114612c66576040519150601f19603f3d011682016040523d82523d6000602084013e612c6b565b606091505b506000815103612ca7576040517fd1a57ed600000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b805181602001fd5b63150b7a0260e01b7bffffffffffffffffffffffffffffffffffffffffffffffffffffffff1916817bffffffffffffffffffffffffffffffffffffffffffffffffffffffff191614915050949350505050565b612d0a613070565b612d1b612d1683612197565b612f22565b9050919050565b6060600b8054612d3190613dd8565b80601f0160208091040260200160405190810160405280929190818152602001828054612d5d90613dd8565b8015612daa5780601f10612d7f57610100808354040283529160200191612daa565b820191906000526020600020905b815481529060010190602001808311612d8d57829003601f168201915b5050505050905090565b606060a060405101806040526020810391506000825281835b600115612def57600184039350600a81066030018453600a8104905080612dcd575b50828103602084039350808452505050919050565b600080600883901c9050600060ff84166001901b9050600081866000016000858152602001908152602001600020541614159250505092915050565b600067ffffffffffffffff6040600660008573ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002054901c169050919050565b60007f01ffc9a7000000000000000000000000000000000000000000000000000000007bffffffffffffffffffffffffffffffffffffffffffffffffffffffff1916827bffffffffffffffffffffffffffffffffffffffffffffffffffffffff1916149050919050565b600033905090565b60009392505050565b60006001821460e11b9050919050565b612f2a613070565b81816000019073ffffffffffffffffffffffffffffffffffffffff16908173ffffffffffffffffffffffffffffffffffffffff168152505060a082901c816020019067ffffffffffffffff16908167ffffffffffffffff168152505060007c01000000000000000000000000000000000000000000000000000000008316141581604001901515908115158152505060e882901c816060019062ffffff16908162ffffff1681525050919050565b60008082905060005b84518110156130235761300e8286838151811061300157613000613eda565b5b602002602001015161302e565b9150808061301b90614490565b915050612fe1565b508091505092915050565b6000818310613046576130418284613059565b613051565b6130508383613059565b5b905092915050565b600082600052816020526040600020905092915050565b6040518060800160405280600073ffffffffffffffffffffffffffffffffffffffff168152602001600067ffffffffffffffff168152602001600015158152602001600062ffffff1681525090565b6000604051905090565b600080fd5b600080fd5b60007fffffffff0000000000000000000000000000000000000000000000000000000082169050919050565b613108816130d3565b811461311357600080fd5b50565b600081359050613125816130ff565b92915050565b600060208284031215613141576131406130c9565b5b600061314f84828501613116565b91505092915050565b60008115159050919050565b61316d81613158565b82525050565b60006020820190506131886000830184613164565b92915050565b600073ffffffffffffffffffffffffffffffffffffffff82169050919050565b60006131b98261318e565b9050919050565b6131c9816131ae565b81146131d457600080fd5b50565b6000813590506131e6816131c0565b92915050565b60006bffffffffffffffffffffffff82169050919050565b61320d816131ec565b811461321857600080fd5b50565b60008135905061322a81613204565b92915050565b60008060408385031215613247576132466130c9565b5b6000613255858286016131d7565b92505060206132668582860161321b565b9150509250929050565b600081519050919050565b600082825260208201905092915050565b60005b838110156132aa57808201518184015260208101905061328f565b60008484015250505050565b6000601f19601f8301169050919050565b60006132d282613270565b6132dc818561327b565b93506132ec81856020860161328c565b6132f5816132b6565b840191505092915050565b6000602082019050818103600083015261331a81846132c7565b905092915050565b6000819050919050565b61333581613322565b811461334057600080fd5b50565b6000813590506133528161332c565b92915050565b60006020828403121561336e5761336d6130c9565b5b600061337c84828501613343565b91505092915050565b61338e816131ae565b82525050565b60006020820190506133a96000830184613385565b92915050565b600080604083850312156133c6576133c56130c9565b5b60006133d4858286016131d7565b92505060206133e585828601613343565b9150509250929050565b6133f881613322565b82525050565b600060208201905061341360008301846133ef565b92915050565b600080600060608486031215613432576134316130c9565b5b6000613440868287016131d7565b9350506020613451868287016131d7565b925050604061346286828701613343565b9150509250925092565b60008060408385031215613483576134826130c9565b5b600061349185828601613343565b92505060206134a285828601613343565b9150509250929050565b60006040820190506134c16000830185613385565b6134ce60208301846133ef565b9392505050565b6000819050919050565b6134e8816134d5565b81146134f357600080fd5b50565b600081359050613505816134df565b92915050565b600060208284031215613521576135206130c9565b5b600061352f848285016134f6565b91505092915050565b600080600060608486031215613551576135506130c9565b5b600061355f86828701613343565b9350506020613570868287016131d7565b92505060406135818682870161321b565b9150509250925092565b600080fd5b600080fd5b600080fd5b60008083601f8401126135b0576135af61358b565b5b8235905067ffffffffffffffff8111156135cd576135cc613590565b5b6020830191508360208202830111156135e9576135e8613595565b5b9250929050565b60008060208385031215613607576136066130c9565b5b600083013567ffffffffffffffff811115613625576136246130ce565b5b6136318582860161359a565b92509250509250929050565b600081519050919050565b600082825260208201905092915050565b6000819050602082019050919050565b613672816131ae565b82525050565b600067ffffffffffffffff82169050919050565b61369581613678565b82525050565b6136a481613158565b82525050565b600062ffffff82169050919050565b6136c2816136aa565b82525050565b6080820160008201516136de6000850182613669565b5060208201516136f1602085018261368c565b506040820151613704604085018261369b565b50606082015161371760608501826136b9565b50505050565b600061372983836136c8565b60808301905092915050565b6000602082019050919050565b600061374d8261363d565b6137578185613648565b935061376283613659565b8060005b8381101561379357815161377a888261371d565b975061378583613735565b925050600181019050613766565b5085935050505092915050565b600060208201905081810360008301526137ba8184613742565b905092915050565b6000602082840312156137d8576137d76130c9565b5b60006137e6848285016131d7565b91505092915050565b6137f881613158565b811461380357600080fd5b50565b600081359050613815816137ef565b92915050565b60008060408385031215613832576138316130c9565b5b6000613840858286016131d7565b925050602061385185828601613806565b9150509250929050565b600081519050919050565b600082825260208201905092915050565b6000819050602082019050919050565b61389081613322565b82525050565b60006138a28383613887565b60208301905092915050565b6000602082019050919050565b60006138c68261385b565b6138d08185613866565b93506138db83613877565b8060005b8381101561390c5781516138f38882613896565b97506138fe836138ae565b9250506001810190506138df565b5085935050505092915050565b6000602082019050818103600083015261393381846138bb565b905092915050565b60008083601f8401126139515761395061358b565b5b8235905067ffffffffffffffff81111561396e5761396d613590565b5b60208301915083600182028301111561398a57613989613595565b5b9250929050565b600080602083850312156139a8576139a76130c9565b5b600083013567ffffffffffffffff8111156139c6576139c56130ce565b5b6139d28582860161393b565b92509250509250929050565b6000806000606084860312156139f7576139f66130c9565b5b6000613a05868287016131d7565b9350506020613a1686828701613343565b9250506040613a2786828701613343565b9150509250925092565b60008083601f840112613a4757613a4661358b565b5b8235905067ffffffffffffffff811115613a6457613a63613590565b5b602083019150836020820283011115613a8057613a7f613595565b5b9250929050565b600080600080600060608688031215613aa357613aa26130c9565b5b6000613ab188828901613343565b955050602086013567ffffffffffffffff811115613ad257613ad16130ce565b5b613ade8882890161393b565b9450945050604086013567ffffffffffffffff811115613b0157613b006130ce565b5b613b0d88828901613a31565b92509250509295509295909350565b600080fd5b7f4e487b7100000000000000000000000000000000000000000000000000000000600052604160045260246000fd5b613b59826132b6565b810181811067ffffffffffffffff82111715613b7857613b77613b21565b5b80604052505050565b6000613b8b6130bf565b9050613b978282613b50565b919050565b600067ffffffffffffffff821115613bb757613bb6613b21565b5b613bc0826132b6565b9050602081019050919050565b82818337600083830152505050565b6000613bef613bea84613b9c565b613b81565b905082815260208101848484011115613c0b57613c0a613b1c565b5b613c16848285613bcd565b509392505050565b600082601f830112613c3357613c3261358b565b5b8135613c43848260208601613bdc565b91505092915050565b60008060008060808587031215613c6657613c656130c9565b5b6000613c74878288016131d7565b9450506020613c85878288016131d7565b9350506040613c9687828801613343565b925050606085013567ffffffffffffffff811115613cb757613cb66130ce565b5b613cc387828801613c1e565b91505092959194509250565b608082016000820151613ce56000850182613669565b506020820151613cf8602085018261368c565b506040820151613d0b604085018261369b565b506060820151613d1e60608501826136b9565b50505050565b6000608082019050613d396000830184613ccf565b92915050565b613d48816134d5565b82525050565b6000602082019050613d636000830184613d3f565b92915050565b60008060408385031215613d8057613d7f6130c9565b5b6000613d8e858286016131d7565b9250506020613d9f858286016131d7565b9150509250929050565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052602260045260246000fd5b60006002820490506001821680613df057607f821691505b602082108103613e0357613e02613da9565b5b50919050565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052601160045260246000fd5b6000613e4382613322565b9150613e4e83613322565b9250828202613e5c81613322565b91508282048414831517613e7357613e72613e09565b5b5092915050565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052601260045260246000fd5b6000613eb482613322565b9150613ebf83613322565b925082613ecf57613ece613e7a565b5b828204905092915050565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052603260045260246000fd5b600082905092915050565b60008190508160005260206000209050919050565b60006020601f8301049050919050565b600082821b905092915050565b600060088302613f767fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff82613f39565b613f808683613f39565b95508019841693508086168417925050509392505050565b6000819050919050565b6000613fbd613fb8613fb384613322565b613f98565b613322565b9050919050565b6000819050919050565b613fd783613fa2565b613feb613fe382613fc4565b848454613f46565b825550505050565b600090565b614000613ff3565b61400b818484613fce565b505050565b5b8181101561402f57614024600082613ff8565b600181019050614011565b5050565b601f8211156140745761404581613f14565b61404e84613f29565b8101602085101561405d578190505b61407161406985613f29565b830182614010565b50505b505050565b600082821c905092915050565b600061409760001984600802614079565b1980831691505092915050565b60006140b08383614086565b9150826002028217905092915050565b6140ca8383613f09565b67ffffffffffffffff8111156140e3576140e2613b21565b5b6140ed8254613dd8565b6140f8828285614033565b6000601f8311600181146141275760008415614115578287013590505b61411f85826140a4565b865550614187565b601f19841661413586613f14565b60005b8281101561415d57848901358255600182019150602085019450602081019050614138565b8683101561417a5784890135614176601f891682614086565b8355505b6001600288020188555050505b50505050505050565b6000819050919050565b6141ab6141a682613322565b614190565b82525050565b600081905092915050565b60006141c883856141b1565b93506141d5838584613bcd565b82840190509392505050565b60006141ed828661419a565b6020820191506141fe8284866141bc565b9150819050949350505050565b600061421682613270565b61422081856141b1565b935061423081856020860161328c565b80840191505092915050565b6000614248828561420b565b9150614254828461420b565b91508190509392505050565b7f4f776e61626c653a206e6577206f776e657220697320746865207a65726f206160008201527f6464726573730000000000000000000000000000000000000000000000000000602082015250565b60006142bc60268361327b565b91506142c782614260565b604082019050919050565b600060208201905081810360008301526142eb816142af565b9050919050565b7f4f776e61626c653a2063616c6c6572206973206e6f7420746865206f776e6572600082015250565b600061432860208361327b565b9150614333826142f2565b602082019050919050565b600060208201905081810360008301526143578161431b565b9050919050565b7f455243323938313a20726f79616c7479206665652077696c6c2065786365656460008201527f2073616c65507269636500000000000000000000000000000000000000000000602082015250565b60006143ba602a8361327b565b91506143c58261435e565b604082019050919050565b600060208201905081810360008301526143e9816143ad565b9050919050565b7f455243323938313a20696e76616c696420726563656976657200000000000000600082015250565b600061442660198361327b565b9150614431826143f0565b602082019050919050565b6000602082019050818103600083015261445581614419565b9050919050565b600061446782613322565b915061447283613322565b925082820190508082111561448a57614489613e09565b5b92915050565b600061449b82613322565b91507fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff82036144cd576144cc613e09565b5b600182019050919050565b7f455243323938313a20496e76616c696420706172616d65746572730000000000600082015250565b600061450e601b8361327b565b9150614519826144d8565b602082019050919050565b6000602082019050818103600083015261453d81614501565b9050919050565b600081519050919050565b600082825260208201905092915050565b600061456b82614544565b614575818561454f565b935061458581856020860161328c565b61458e816132b6565b840191505092915050565b60006080820190506145ae6000830187613385565b6145bb6020830186613385565b6145c860408301856133ef565b81810360608301526145da8184614560565b905095945050505050565b6000815190506145f4816130ff565b92915050565b6000602082840312156146105761460f6130c9565b5b600061461e848285016145e5565b9150509291505056fea2646970667358221220b89d6237c99a6387f7a2670cb12ed4de71811cc38f2ca536a357283ea65f2b1e64736f6c63430008120033",
    "deployedBytecode": "0x6080604052600436106102305760003560e01c806370a082311161012e578063a22cb465116100ab578063c92243d81161006f578063c92243d814610860578063cd837b061461089d578063e985e9c5146108c8578063f2fde38b14610905578063f8c75f5d1461092e57610230565b8063a22cb46514610764578063b2a94ec51461078d578063b88d4fde146107ca578063c23dc68f146107e6578063c87b56dd1461082357610230565b80638da5cb5b116100f25780638da5cb5b1461067d57806395652cfa146106a857806395d89b41146106d157806399a2557a146106fc5780639a1662991461073957610230565b806370a0823114610598578063711bf9b2146105d5578063715018a6146105fe57806375794a3c146106155780638462151c1461064057610230565b80633e4045cc116101bc5780634c738909116101805780634c7389091461048d5780635944c753146104b85780635bbb2177146104e15780636352211e1461051e57806364bd7a3a1461055b57610230565b80633e4045cc146103cd57806340c10f19146103f657806342842e0e1461041f57806342966c681461043b578063477f1d571461046457610230565b8063095ea7b311610203578063095ea7b31461030357806318160ddd1461031f57806323b872dd1461034a578063275ec991146103665780632a55205a1461038f57610230565b806301ffc9a71461023557806304634d8d1461027257806306fdde031461029b578063081812fc146102c6575b600080fd5b34801561024157600080fd5b5061025c6004803603810190610257919061312b565b61096b565b6040516102699190613173565b60405180910390f35b34801561027e57600080fd5b5061029960048036038101906102949190613230565b61098d565b005b3480156102a757600080fd5b506102b06109a3565b6040516102bd9190613300565b60405180910390f35b3480156102d257600080fd5b506102ed60048036038101906102e89190613358565b610a35565b6040516102fa9190613394565b60405180910390f35b61031d600480360381019061031891906133af565b610ab4565b005b34801561032b57600080fd5b50610334610bf8565b60405161034191906133fe565b60405180910390f35b610364600480360381019061035f9190613419565b610c0f565b005b34801561037257600080fd5b5061038d60048036038101906103889190613358565b610f31565b005b34801561039b57600080fd5b506103b660048036038101906103b1919061346c565b610fcb565b6040516103c49291906134ac565b60405180910390f35b3480156103d957600080fd5b506103f460048036038101906103ef919061350b565b6111b5565b005b34801561040257600080fd5b5061041d600480360381019061041891906133af565b6111c7565b005b61043960048036038101906104349190613419565b611258565b005b34801561044757600080fd5b50610462600480360381019061045d9190613358565b611278565b005b34801561047057600080fd5b5061048b60048036038101906104869190613358565b611286565b005b34801561049957600080fd5b506104a2611320565b6040516104af91906133fe565b60405180910390f35b3480156104c457600080fd5b506104df60048036038101906104da9190613538565b61133f565b005b3480156104ed57600080fd5b50610508600480360381019061050391906135f0565b611357565b60405161051591906137a0565b60405180910390f35b34801561052a57600080fd5b5061054560048036038101906105409190613358565b61141a565b6040516105529190613394565b60405180910390f35b34801561056757600080fd5b50610582600480360381019061057d91906137c2565b61142c565b60405161058f91906133fe565b60405180910390f35b3480156105a457600080fd5b506105bf60048036038101906105ba91906137c2565b61143e565b6040516105cc91906133fe565b60405180910390f35b3480156105e157600080fd5b506105fc60048036038101906105f7919061381b565b6114f6565b005b34801561060a57600080fd5b50610613611559565b005b34801561062157600080fd5b5061062a61156d565b60405161063791906133fe565b60405180910390f35b34801561064c57600080fd5b50610667600480360381019061066291906137c2565b61157c565b6040516106749190613919565b60405180910390f35b34801561068957600080fd5b506106926116bf565b60405161069f9190613394565b60405180910390f35b3480156106b457600080fd5b506106cf60048036038101906106ca9190613991565b6116e8565b005b3480156106dd57600080fd5b506106e6611706565b6040516106f39190613300565b60405180910390f35b34801561070857600080fd5b50610723600480360381019061071e91906139de565b611798565b6040516107309190613919565b60405180910390f35b34801561074557600080fd5b5061074e6119a4565b60405161075b9190613394565b60405180910390f35b34801561077057600080fd5b5061078b6004803603810190610786919061381b565b6119ac565b005b34801561079957600080fd5b506107b460048036038101906107af9190613a87565b611ab7565b6040516107c19190613173565b60405180910390f35b6107e460048036038101906107df9190613c4c565b611b41565b005b3480156107f257600080fd5b5061080d60048036038101906108089190613358565b611bb4565b60405161081a9190613d24565b60405180910390f35b34801561082f57600080fd5b5061084a60048036038101906108459190613358565b611c1e565b6040516108579190613300565b60405180910390f35b34801561086c57600080fd5b5061088760048036038101906108829190613358565b611cbc565b6040516108949190613173565b60405180910390f35b3480156108a957600080fd5b506108b2611cd9565b6040516108bf9190613d4e565b60405180910390f35b3480156108d457600080fd5b506108ef60048036038101906108ea9190613d69565b611cdf565b6040516108fc9190613173565b60405180910390f35b34801561091157600080fd5b5061092c600480360381019061092791906137c2565b611d73565b005b34801561093a57600080fd5b50610955600480360381019061095091906137c2565b611df6565b60405161096291906133fe565b60405180910390f35b600061097682611e08565b80610986575061098582611e82565b5b9050919050565b610995611f14565b61099f8282611f92565b5050565b6060600380546109b290613dd8565b80601f01602080910402602001604051908101604052809291908181526020018280546109de90613dd8565b8015610a2b5780601f10610a0057610100808354040283529160200191610a2b565b820191906000526020600020905b815481529060010190602001808311610a0e57829003601f168201915b5050505050905090565b6000610a4082612127565b610a76576040517fcf4700e400000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b6007600083815260200190815260200160002060000160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff169050919050565b6000610abf8261141a565b90508073ffffffffffffffffffffffffffffffffffffffff16610ae0612186565b73ffffffffffffffffffffffffffffffffffffffff1614610b4357610b0c81610b07612186565b611cdf565b610b42576040517fcfb3b94200000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b5b826007600084815260200190815260200160002060000160006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff160217905550818373ffffffffffffffffffffffffffffffffffffffff168273ffffffffffffffffffffffffffffffffffffffff167f8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b92560405160405180910390a4505050565b6000610c0261218e565b6002546001540303905090565b6000610c1a82612197565b90508373ffffffffffffffffffffffffffffffffffffffff168173ffffffffffffffffffffffffffffffffffffffff1614610c81576040517fa114810000000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b600080610c8d84612263565b91509150610ca38187610c9e612186565b61228a565b610cef57610cb886610cb3612186565b611cdf565b610cee576040517f59c896be00000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b5b600073ffffffffffffffffffffffffffffffffffffffff168573ffffffffffffffffffffffffffffffffffffffff1603610d55576040517fea553b3400000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b610d6286868660016122ce565b8015610d6d57600082555b600660008773ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020600081546001900391905081905550600660008673ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000206000815460010191905081905550610e3b85610e178888876123b6565b7c0200000000000000000000000000000000000000000000000000000000176123de565b600560008681526020019081526020016000208190555060007c0200000000000000000000000000000000000000000000000000000000841603610ec15760006001850190506000600560008381526020019081526020016000205403610ebf576001548114610ebe578360056000838152602001908152602001600020819055505b5b505b838573ffffffffffffffffffffffffffffffffffffffff168773ffffffffffffffffffffffffffffffffffffffff167fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef60405160405180910390a4610f298686866001612409565b505050505050565b600d60003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060009054906101000a900460ff16610fb4576040517fea8e4eb500000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b610fc881600c61240f90919063ffffffff16565b50565b6000806000600a60008681526020019081526020016000206040518060400160405290816000820160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020016000820160149054906101000a90046bffffffffffffffffffffffff166bffffffffffffffffffffffff166bffffffffffffffffffffffff16815250509050600073ffffffffffffffffffffffffffffffffffffffff16816000015173ffffffffffffffffffffffffffffffffffffffff16036111605760096040518060400160405290816000820160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020016000820160149054906101000a90046bffffffffffffffffffffffff166bffffffffffffffffffffffff166bffffffffffffffffffffffff168152505090505b600061116a61244d565b6bffffffffffffffffffffffff1682602001516bffffffffffffffffffffffff16866111969190613e38565b6111a09190613ea9565b90508160000151819350935050509250929050565b6111bd611f14565b80600e8190555050565b600d60003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060009054906101000a900460ff1661124a576040517fea8e4eb500000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b6112548282612457565b5050565b61127383838360405180602001604052806000815250611b41565b505050565b611283816001612613565b50565b600d60003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060009054906101000a900460ff16611309576040517fea8e4eb500000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b61131d81600c61286590919063ffffffff16565b50565b60003373ffffffffffffffffffffffffffffffffffffffff1631905090565b611347611f14565b6113528383836128a4565b505050565b6060600083839050905060008167ffffffffffffffff81111561137d5761137c613b21565b5b6040519080825280602002602001820160405280156113b657816020015b6113a3613070565b81526020019060019003908161139b5790505b50905060005b82811461140e576113e58686838181106113d9576113d8613eda565b5b90506020020135611bb4565b8282815181106113f8576113f7613eda565b5b60200260200101819052508060010190506113bc565b50809250505092915050565b600061142582612197565b9050919050565b600061143782612a4b565b9050919050565b60008073ffffffffffffffffffffffffffffffffffffffff168273ffffffffffffffffffffffffffffffffffffffff16036114a5576040517f8f4eb60400000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b67ffffffffffffffff600660008473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002054169050919050565b6114fe611f14565b80600d60008473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060006101000a81548160ff0219169083151502179055505050565b611561611f14565b61156b6000612aa2565b565b6000611577612b66565b905090565b6060600080600061158c8561143e565b905060008167ffffffffffffffff8111156115aa576115a9613b21565b5b6040519080825280602002602001820160405280156115d85781602001602082028036833780820191505090505b5090506115e3613070565b60006115ed61218e565b90505b8386146116b15761160081612b70565b915081604001516116a657600073ffffffffffffffffffffffffffffffffffffffff16826000015173ffffffffffffffffffffffffffffffffffffffff161461164b57816000015194505b8773ffffffffffffffffffffffffffffffffffffffff168573ffffffffffffffffffffffffffffffffffffffff16036116a5578083878060010198508151811061169857611697613eda565b5b6020026020010181815250505b5b8060010190506115f0565b508195505050505050919050565b60008060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff16905090565b6116f0611f14565b8181600b91826117019291906140c0565b505050565b60606004805461171590613dd8565b80601f016020809104026020016040519081016040528092919081815260200182805461174190613dd8565b801561178e5780601f106117635761010080835404028352916020019161178e565b820191906000526020600020905b81548152906001019060200180831161177157829003601f168201915b5050505050905090565b60608183106117d3576040517f32c1995a00000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b6000806117de612b66565b90506117e861218e565b8510156117fa576117f761218e565b94505b80841115611806578093505b60006118118761143e565b90508486101561183457600086860390508181101561182e578091505b50611839565b600090505b60008167ffffffffffffffff81111561185557611854613b21565b5b6040519080825280602002602001820160405280156118835781602001602082028036833780820191505090505b5090506000820361189a578094505050505061199d565b60006118a588611bb4565b9050600081604001516118ba57816000015190505b60008990505b8881141580156118d05750848714155b1561198f576118de81612b70565b9250826040015161198457600073ffffffffffffffffffffffffffffffffffffffff16836000015173ffffffffffffffffffffffffffffffffffffffff161461192957826000015191505b8a73ffffffffffffffffffffffffffffffffffffffff168273ffffffffffffffffffffffffffffffffffffffff1603611983578084888060010199508151811061197657611975613eda565b5b6020026020010181815250505b5b8060010190506118c0565b508583528296505050505050505b9392505050565b600033905090565b80600860006119b9612186565b73ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060008473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060006101000a81548160ff0219169083151502179055508173ffffffffffffffffffffffffffffffffffffffff16611a66612186565b73ffffffffffffffffffffffffffffffffffffffff167f17307eab39ab6107e8899845ad3d59bd9653f200f220920489ca2b5937696c3183604051611aab9190613173565b60405180910390a35050565b600080868686604051602001611acf939291906141e1565b604051602081830303815290604052805190602001209050611b35848480806020026020016040519081016040528093929190818152602001838360200280828437600081840152601f19601f82011690508083019250505050505050600e5483612b9b565b91505095945050505050565b611b4c848484610c0f565b60008373ffffffffffffffffffffffffffffffffffffffff163b14611bae57611b7784848484612bb2565b611bad576040517fd1a57ed600000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b5b50505050565b611bbc613070565b611bc4613070565b611bcc61218e565b831080611be05750611bdc612b66565b8310155b15611bee5780915050611c19565b611bf783612b70565b9050806040015115611c0c5780915050611c19565b611c1583612d02565b9150505b919050565b6060611c2982612127565b611c5f576040517fa14c4b5000000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b6000611c69612d22565b90506000815103611c895760405180602001604052806000815250611cb4565b80611c9384612db4565b604051602001611ca492919061423c565b6040516020818303038152906040525b915050919050565b6000611cd282600c612e0490919063ffffffff16565b9050919050565b600e5481565b6000600860008473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060008373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060009054906101000a900460ff16905092915050565b611d7b611f14565b600073ffffffffffffffffffffffffffffffffffffffff168173ffffffffffffffffffffffffffffffffffffffff1603611dea576040517f08c379a0000000000000000000000000000000000000000000000000000000008152600401611de1906142d2565b60405180910390fd5b611df381612aa2565b50565b6000611e0182612e40565b9050919050565b60007f2a55205a000000000000000000000000000000000000000000000000000000007bffffffffffffffffffffffffffffffffffffffffffffffffffffffff1916827bffffffffffffffffffffffffffffffffffffffffffffffffffffffff19161480611e7b5750611e7a82612e97565b5b9050919050565b60006301ffc9a760e01b827bffffffffffffffffffffffffffffffffffffffffffffffffffffffff19161480611edd57506380ac58cd60e01b827bffffffffffffffffffffffffffffffffffffffffffffffffffffffff1916145b80611f0d5750635b5e139f60e01b827bffffffffffffffffffffffffffffffffffffffffffffffffffffffff1916145b9050919050565b611f1c612f01565b73ffffffffffffffffffffffffffffffffffffffff16611f3a6116bf565b73ffffffffffffffffffffffffffffffffffffffff1614611f90576040517f08c379a0000000000000000000000000000000000000000000000000000000008152600401611f879061433e565b60405180910390fd5b565b611f9a61244d565b6bffffffffffffffffffffffff16816bffffffffffffffffffffffff161115611ff8576040517f08c379a0000000000000000000000000000000000000000000000000000000008152600401611fef906143d0565b60405180910390fd5b600073ffffffffffffffffffffffffffffffffffffffff168273ffffffffffffffffffffffffffffffffffffffff1603612067576040517f08c379a000000000000000000000000000000000000000000000000000000000815260040161205e9061443c565b60405180910390fd5b60405180604001604052808373ffffffffffffffffffffffffffffffffffffffff168152602001826bffffffffffffffffffffffff16815250600960008201518160000160006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff16021790555060208201518160000160146101000a8154816bffffffffffffffffffffffff02191690836bffffffffffffffffffffffff1602179055509050505050565b60008161213261218e565b11158015612141575060015482105b801561217f575060007c0100000000000000000000000000000000000000000000000000000000600560008581526020019081526020016000205416145b9050919050565b600033905090565b60006001905090565b600080829050806121a661218e565b1161222c5760015481101561222b5760006005600083815260200190815260200160002054905060007c0100000000000000000000000000000000000000000000000000000000821603612229575b6000810361221f5760056000836001900393508381526020019081526020016000205490506121f5565b809250505061225e565b505b5b6040517fdf2d9b4200000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b919050565b60008060006007600085815260200190815260200160002090508092508254915050915091565b600073ffffffffffffffffffffffffffffffffffffffff8316925073ffffffffffffffffffffffffffffffffffffffff821691508382148383141790509392505050565b600073ffffffffffffffffffffffffffffffffffffffff168473ffffffffffffffffffffffffffffffffffffffff1614806123355750600073ffffffffffffffffffffffffffffffffffffffff168373ffffffffffffffffffffffffffffffffffffffff16145b6123b05760008290505b818361234b919061445c565b8110156123ae5761236681600c612e0490919063ffffffff16565b1561239d576040517fc1ab6dc100000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b806123a790614490565b905061233f565b505b50505050565b60008060e883901c905060e86123cd868684612f09565b62ffffff16901b9150509392505050565b600073ffffffffffffffffffffffffffffffffffffffff83169250814260a01b178317905092915050565b50505050565b6000600882901c9050600060ff83166001901b9050808460000160008481526020019081526020016000206000828254179250508190555050505050565b6000612710905090565b6000600154905060008203612498576040517fb562e8dd00000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b6124a560008483856122ce565b600160406001901b178202600660008573ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000206000828254019250508190555061251c8361250d60008660006123b6565b61251685612f12565b176123de565b6005600083815260200190815260200160002081905550600080838301905073ffffffffffffffffffffffffffffffffffffffff85169150828260007fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef600080a4600183015b8181146125bd57808360007fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef600080a4600181019050612582565b50600082036125f8576040517f2e07630000000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b80600181905550505061260e6000848385612409565b505050565b600061261e83612197565b9050600081905060008061263186612263565b91509150841561269a5761264d8184612648612186565b61228a565b612699576126628361265d612186565b611cdf565b612698576040517f59c896be00000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b5b5b6126a88360008860016122ce565b80156126b357600082555b600160806001901b03600660008573ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000206000828254019250508190555061275b83612718856000886123b6565b7c02000000000000000000000000000000000000000000000000000000007c010000000000000000000000000000000000000000000000000000000017176123de565b600560008881526020019081526020016000208190555060007c02000000000000000000000000000000000000000000000000000000008516036127e157600060018701905060006005600083815260200190815260200160002054036127df5760015481146127de578460056000838152602001908152602001600020819055505b5b505b85600073ffffffffffffffffffffffffffffffffffffffff168473ffffffffffffffffffffffffffffffffffffffff167fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef60405160405180910390a461284b836000886001612409565b600260008154809291906001019190505550505050505050565b6000600882901c9050600060ff83166001901b905080198460000160008481526020019081526020016000206000828254169250508190555050505050565b6128ac61244d565b6bffffffffffffffffffffffff16816bffffffffffffffffffffffff16111561290a576040517f08c379a0000000000000000000000000000000000000000000000000000000008152600401612901906143d0565b60405180910390fd5b600073ffffffffffffffffffffffffffffffffffffffff168273ffffffffffffffffffffffffffffffffffffffff1603612979576040517f08c379a000000000000000000000000000000000000000000000000000000000815260040161297090614524565b60405180910390fd5b60405180604001604052808373ffffffffffffffffffffffffffffffffffffffff168152602001826bffffffffffffffffffffffff16815250600a600085815260200190815260200160002060008201518160000160006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff16021790555060208201518160000160146101000a8154816bffffffffffffffffffffffff02191690836bffffffffffffffffffffffff160217905550905050505050565b600067ffffffffffffffff6080600660008573ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002054901c169050919050565b60008060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff169050816000806101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff1602179055508173ffffffffffffffffffffffffffffffffffffffff168173ffffffffffffffffffffffffffffffffffffffff167f8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e060405160405180910390a35050565b6000600154905090565b612b78613070565b612b946005600084815260200190815260200160002054612f22565b9050919050565b600082612ba88584612fd8565b1490509392505050565b60008373ffffffffffffffffffffffffffffffffffffffff1663150b7a02612bd8612186565b8786866040518563ffffffff1660e01b8152600401612bfa9493929190614599565b6020604051808303816000875af1925050508015612c3657506040513d601f19601f82011682018060405250810190612c3391906145fa565b60015b612caf573d8060008114612c66576040519150601f19603f3d011682016040523d82523d6000602084013e612c6b565b606091505b506000815103612ca7576040517fd1a57ed600000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b805181602001fd5b63150b7a0260e01b7bffffffffffffffffffffffffffffffffffffffffffffffffffffffff1916817bffffffffffffffffffffffffffffffffffffffffffffffffffffffff191614915050949350505050565b612d0a613070565b612d1b612d1683612197565b612f22565b9050919050565b6060600b8054612d3190613dd8565b80601f0160208091040260200160405190810160405280929190818152602001828054612d5d90613dd8565b8015612daa5780601f10612d7f57610100808354040283529160200191612daa565b820191906000526020600020905b815481529060010190602001808311612d8d57829003601f168201915b5050505050905090565b606060a060405101806040526020810391506000825281835b600115612def57600184039350600a81066030018453600a8104905080612dcd575b50828103602084039350808452505050919050565b600080600883901c9050600060ff84166001901b9050600081866000016000858152602001908152602001600020541614159250505092915050565b600067ffffffffffffffff6040600660008573ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002054901c169050919050565b60007f01ffc9a7000000000000000000000000000000000000000000000000000000007bffffffffffffffffffffffffffffffffffffffffffffffffffffffff1916827bffffffffffffffffffffffffffffffffffffffffffffffffffffffff1916149050919050565b600033905090565b60009392505050565b60006001821460e11b9050919050565b612f2a613070565b81816000019073ffffffffffffffffffffffffffffffffffffffff16908173ffffffffffffffffffffffffffffffffffffffff168152505060a082901c816020019067ffffffffffffffff16908167ffffffffffffffff168152505060007c01000000000000000000000000000000000000000000000000000000008316141581604001901515908115158152505060e882901c816060019062ffffff16908162ffffff1681525050919050565b60008082905060005b84518110156130235761300e8286838151811061300157613000613eda565b5b602002602001015161302e565b9150808061301b90614490565b915050612fe1565b508091505092915050565b6000818310613046576130418284613059565b613051565b6130508383613059565b5b905092915050565b600082600052816020526040600020905092915050565b6040518060800160405280600073ffffffffffffffffffffffffffffffffffffffff168152602001600067ffffffffffffffff168152602001600015158152602001600062ffffff1681525090565b6000604051905090565b600080fd5b600080fd5b60007fffffffff0000000000000000000000000000000000000000000000000000000082169050919050565b613108816130d3565b811461311357600080fd5b50565b600081359050613125816130ff565b92915050565b600060208284031215613141576131406130c9565b5b600061314f84828501613116565b91505092915050565b60008115159050919050565b61316d81613158565b82525050565b60006020820190506131886000830184613164565b92915050565b600073ffffffffffffffffffffffffffffffffffffffff82169050919050565b60006131b98261318e565b9050919050565b6131c9816131ae565b81146131d457600080fd5b50565b6000813590506131e6816131c0565b92915050565b60006bffffffffffffffffffffffff82169050919050565b61320d816131ec565b811461321857600080fd5b50565b60008135905061322a81613204565b92915050565b60008060408385031215613247576132466130c9565b5b6000613255858286016131d7565b92505060206132668582860161321b565b9150509250929050565b600081519050919050565b600082825260208201905092915050565b60005b838110156132aa57808201518184015260208101905061328f565b60008484015250505050565b6000601f19601f8301169050919050565b60006132d282613270565b6132dc818561327b565b93506132ec81856020860161328c565b6132f5816132b6565b840191505092915050565b6000602082019050818103600083015261331a81846132c7565b905092915050565b6000819050919050565b61333581613322565b811461334057600080fd5b50565b6000813590506133528161332c565b92915050565b60006020828403121561336e5761336d6130c9565b5b600061337c84828501613343565b91505092915050565b61338e816131ae565b82525050565b60006020820190506133a96000830184613385565b92915050565b600080604083850312156133c6576133c56130c9565b5b60006133d4858286016131d7565b92505060206133e585828601613343565b9150509250929050565b6133f881613322565b82525050565b600060208201905061341360008301846133ef565b92915050565b600080600060608486031215613432576134316130c9565b5b6000613440868287016131d7565b9350506020613451868287016131d7565b925050604061346286828701613343565b9150509250925092565b60008060408385031215613483576134826130c9565b5b600061349185828601613343565b92505060206134a285828601613343565b9150509250929050565b60006040820190506134c16000830185613385565b6134ce60208301846133ef565b9392505050565b6000819050919050565b6134e8816134d5565b81146134f357600080fd5b50565b600081359050613505816134df565b92915050565b600060208284031215613521576135206130c9565b5b600061352f848285016134f6565b91505092915050565b600080600060608486031215613551576135506130c9565b5b600061355f86828701613343565b9350506020613570868287016131d7565b92505060406135818682870161321b565b9150509250925092565b600080fd5b600080fd5b600080fd5b60008083601f8401126135b0576135af61358b565b5b8235905067ffffffffffffffff8111156135cd576135cc613590565b5b6020830191508360208202830111156135e9576135e8613595565b5b9250929050565b60008060208385031215613607576136066130c9565b5b600083013567ffffffffffffffff811115613625576136246130ce565b5b6136318582860161359a565b92509250509250929050565b600081519050919050565b600082825260208201905092915050565b6000819050602082019050919050565b613672816131ae565b82525050565b600067ffffffffffffffff82169050919050565b61369581613678565b82525050565b6136a481613158565b82525050565b600062ffffff82169050919050565b6136c2816136aa565b82525050565b6080820160008201516136de6000850182613669565b5060208201516136f1602085018261368c565b506040820151613704604085018261369b565b50606082015161371760608501826136b9565b50505050565b600061372983836136c8565b60808301905092915050565b6000602082019050919050565b600061374d8261363d565b6137578185613648565b935061376283613659565b8060005b8381101561379357815161377a888261371d565b975061378583613735565b925050600181019050613766565b5085935050505092915050565b600060208201905081810360008301526137ba8184613742565b905092915050565b6000602082840312156137d8576137d76130c9565b5b60006137e6848285016131d7565b91505092915050565b6137f881613158565b811461380357600080fd5b50565b600081359050613815816137ef565b92915050565b60008060408385031215613832576138316130c9565b5b6000613840858286016131d7565b925050602061385185828601613806565b9150509250929050565b600081519050919050565b600082825260208201905092915050565b6000819050602082019050919050565b61389081613322565b82525050565b60006138a28383613887565b60208301905092915050565b6000602082019050919050565b60006138c68261385b565b6138d08185613866565b93506138db83613877565b8060005b8381101561390c5781516138f38882613896565b97506138fe836138ae565b9250506001810190506138df565b5085935050505092915050565b6000602082019050818103600083015261393381846138bb565b905092915050565b60008083601f8401126139515761395061358b565b5b8235905067ffffffffffffffff81111561396e5761396d613590565b5b60208301915083600182028301111561398a57613989613595565b5b9250929050565b600080602083850312156139a8576139a76130c9565b5b600083013567ffffffffffffffff8111156139c6576139c56130ce565b5b6139d28582860161393b565b92509250509250929050565b6000806000606084860312156139f7576139f66130c9565b5b6000613a05868287016131d7565b9350506020613a1686828701613343565b9250506040613a2786828701613343565b9150509250925092565b60008083601f840112613a4757613a4661358b565b5b8235905067ffffffffffffffff811115613a6457613a63613590565b5b602083019150836020820283011115613a8057613a7f613595565b5b9250929050565b600080600080600060608688031215613aa357613aa26130c9565b5b6000613ab188828901613343565b955050602086013567ffffffffffffffff811115613ad257613ad16130ce565b5b613ade8882890161393b565b9450945050604086013567ffffffffffffffff811115613b0157613b006130ce565b5b613b0d88828901613a31565b92509250509295509295909350565b600080fd5b7f4e487b7100000000000000000000000000000000000000000000000000000000600052604160045260246000fd5b613b59826132b6565b810181811067ffffffffffffffff82111715613b7857613b77613b21565b5b80604052505050565b6000613b8b6130bf565b9050613b978282613b50565b919050565b600067ffffffffffffffff821115613bb757613bb6613b21565b5b613bc0826132b6565b9050602081019050919050565b82818337600083830152505050565b6000613bef613bea84613b9c565b613b81565b905082815260208101848484011115613c0b57613c0a613b1c565b5b613c16848285613bcd565b509392505050565b600082601f830112613c3357613c3261358b565b5b8135613c43848260208601613bdc565b91505092915050565b60008060008060808587031215613c6657613c656130c9565b5b6000613c74878288016131d7565b9450506020613c85878288016131d7565b9350506040613c9687828801613343565b925050606085013567ffffffffffffffff811115613cb757613cb66130ce565b5b613cc387828801613c1e565b91505092959194509250565b608082016000820151613ce56000850182613669565b506020820151613cf8602085018261368c565b506040820151613d0b604085018261369b565b506060820151613d1e60608501826136b9565b50505050565b6000608082019050613d396000830184613ccf565b92915050565b613d48816134d5565b82525050565b6000602082019050613d636000830184613d3f565b92915050565b60008060408385031215613d8057613d7f6130c9565b5b6000613d8e858286016131d7565b9250506020613d9f858286016131d7565b9150509250929050565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052602260045260246000fd5b60006002820490506001821680613df057607f821691505b602082108103613e0357613e02613da9565b5b50919050565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052601160045260246000fd5b6000613e4382613322565b9150613e4e83613322565b9250828202613e5c81613322565b91508282048414831517613e7357613e72613e09565b5b5092915050565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052601260045260246000fd5b6000613eb482613322565b9150613ebf83613322565b925082613ecf57613ece613e7a565b5b828204905092915050565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052603260045260246000fd5b600082905092915050565b60008190508160005260206000209050919050565b60006020601f8301049050919050565b600082821b905092915050565b600060088302613f767fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff82613f39565b613f808683613f39565b95508019841693508086168417925050509392505050565b6000819050919050565b6000613fbd613fb8613fb384613322565b613f98565b613322565b9050919050565b6000819050919050565b613fd783613fa2565b613feb613fe382613fc4565b848454613f46565b825550505050565b600090565b614000613ff3565b61400b818484613fce565b505050565b5b8181101561402f57614024600082613ff8565b600181019050614011565b5050565b601f8211156140745761404581613f14565b61404e84613f29565b8101602085101561405d578190505b61407161406985613f29565b830182614010565b50505b505050565b600082821c905092915050565b600061409760001984600802614079565b1980831691505092915050565b60006140b08383614086565b9150826002028217905092915050565b6140ca8383613f09565b67ffffffffffffffff8111156140e3576140e2613b21565b5b6140ed8254613dd8565b6140f8828285614033565b6000601f8311600181146141275760008415614115578287013590505b61411f85826140a4565b865550614187565b601f19841661413586613f14565b60005b8281101561415d57848901358255600182019150602085019450602081019050614138565b8683101561417a5784890135614176601f891682614086565b8355505b6001600288020188555050505b50505050505050565b6000819050919050565b6141ab6141a682613322565b614190565b82525050565b600081905092915050565b60006141c883856141b1565b93506141d5838584613bcd565b82840190509392505050565b60006141ed828661419a565b6020820191506141fe8284866141bc565b9150819050949350505050565b600061421682613270565b61422081856141b1565b935061423081856020860161328c565b80840191505092915050565b6000614248828561420b565b9150614254828461420b565b91508190509392505050565b7f4f776e61626c653a206e6577206f776e657220697320746865207a65726f206160008201527f6464726573730000000000000000000000000000000000000000000000000000602082015250565b60006142bc60268361327b565b91506142c782614260565b604082019050919050565b600060208201905081810360008301526142eb816142af565b9050919050565b7f4f776e61626c653a2063616c6c6572206973206e6f7420746865206f776e6572600082015250565b600061432860208361327b565b9150614333826142f2565b602082019050919050565b600060208201905081810360008301526143578161431b565b9050919050565b7f455243323938313a20726f79616c7479206665652077696c6c2065786365656460008201527f2073616c65507269636500000000000000000000000000000000000000000000602082015250565b60006143ba602a8361327b565b91506143c58261435e565b604082019050919050565b600060208201905081810360008301526143e9816143ad565b9050919050565b7f455243323938313a20696e76616c696420726563656976657200000000000000600082015250565b600061442660198361327b565b9150614431826143f0565b602082019050919050565b6000602082019050818103600083015261445581614419565b9050919050565b600061446782613322565b915061447283613322565b925082820190508082111561448a57614489613e09565b5b92915050565b600061449b82613322565b91507fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff82036144cd576144cc613e09565b5b600182019050919050565b7f455243323938313a20496e76616c696420706172616d65746572730000000000600082015250565b600061450e601b8361327b565b9150614519826144d8565b602082019050919050565b6000602082019050818103600083015261453d81614501565b9050919050565b600081519050919050565b600082825260208201905092915050565b600061456b82614544565b614575818561454f565b935061458581856020860161328c565b61458e816132b6565b840191505092915050565b60006080820190506145ae6000830187613385565b6145bb6020830186613385565b6145c860408301856133ef565b81810360608301526145da8184614560565b905095945050505050565b6000815190506145f4816130ff565b92915050565b6000602082840312156146105761460f6130c9565b5b600061461e848285016145e5565b9150509291505056fea2646970667358221220b89d6237c99a6387f7a2670cb12ed4de71811cc38f2ca536a357283ea65f2b1e64736f6c63430008120033",
    "linkReferences": {},
    "deployedLinkReferences": {}
  }
"""
