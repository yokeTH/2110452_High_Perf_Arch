//
//  main.swift
//  2110452_High_Perf_Arch
//
//  Created by Thanapon Johdee on 26/1/2568 BE.
//

import Foundation
import simd

func addVectorSimd(size: Int, a: inout [Int], b: [Int]) {
    for i in stride(from: 0, to: size - size%16, by: 16) {
        let vectorA = SIMD16<Int>(a[i], a[i+1], a[i+2], a[i+3],
                                 a[i+4],a[i+5], a[i+6], a[i+7],
                                 a[i+8], a[i+9], a[i+10], a[i+11],
                                 a[i+12], a[i+13], a[i+14], a[i+15])
        let vectorB = SIMD16<Int>(b[i], b[i+1], b[i+2], b[i+3],
                                 b[i+4],b[i+5], b[i+6], b[i+7],
                                 b[i+8], b[i+9], b[i+10], b[i+11],
                                 b[i+12], b[i+13], b[i+14], b[i+15])
        let result = vectorA &+ vectorB
        
        // unpack
        a[i+0] = result[0]
        a[i+1] = result[1]
        a[i+2] = result[2]
        a[i+3] = result[3]
        a[i+4] = result[4]
        a[i+5] = result[5]
        a[i+6] = result[6]
        a[i+7] = result[7]
        a[i+8] = result[8]
        a[i+9] = result[9]
        a[i+10] = result[10]
        a[i+11] = result[11]
        a[i+12] = result[12]
        a[i+13] = result[13]
        a[i+14] = result[14]
        a[i+15] = result[15]
    }
    
    let remainderStart = size - size % 16
    for i in remainderStart..<size {
        a[i] += b[i]
    }
}

func addVectorNormal(size: Int, a: inout [Int] , b: [Int]){
    for i in 0..<size {
        a[i] = a[i] + b[i]
    }
}

func generateRandomArray(count: Int, range: ClosedRange<Int>) -> [Int] {
    return (0..<count).map { _ in Int.random(in: range) }
}


func benchMark(size: Int){
    let randomArray1 = generateRandomArray(count: size, range: 1...2147483647)
    let randomArray2 = generateRandomArray(count: size, range: 1...2147483647)
    
    var aForSimd = randomArray1
    let bForSimd = randomArray2
    
    var aForNormal = randomArray1
    let bForNormal = randomArray2
    
    let simdStartTime = DispatchTime.now()
    addVectorSimd(size: aForSimd.count, a: &aForSimd, b: bForSimd)
    let simdEndTime = DispatchTime.now()
    
    let normalStartTime = DispatchTime.now()
    addVectorNormal(size: aForNormal.count, a: &aForNormal, b: bForNormal)
    let normalEndTime = DispatchTime.now()
    
    let simdTime = simdEndTime.uptimeNanoseconds - simdStartTime.uptimeNanoseconds
    let normalTime = normalEndTime.uptimeNanoseconds - normalStartTime.uptimeNanoseconds
    
    print("Array size: \(size)")
    print("Using SIMD take: \(simdTime) ns")
    print("Using loop take: \(normalTime) ns")
    print("Speed Up: \(Double(normalTime) / Double(simdTime))")
}

func main(){
    let sizes = [100, 200, 300, 500, 1000, 10000, 100000, 1000000]
    for size in sizes {
        print("=====\(size)=====")
        benchMark(size: size)
    }

}

main()
