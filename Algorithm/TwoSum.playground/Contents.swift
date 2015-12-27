// Sum 2 numbers equal targer, return indecies of 2 numbers
// return [0, 0] if not found
func twoSum(numbers: [Int], target: Int) -> [Int] {
    var ret: [Int] = [0, 0]
    
    topLoop: for var index1 = 0; index1 < numbers.count; ++index1 {
        for var index2 = 0; index2 < numbers.count; ++index2 {
            if index2 == index1 {
                continue
            }
            
            if numbers[index1] + numbers[index2] == target {
                ret[0] = index1 + 1
                ret[1] = index2 + 1
                break topLoop
            }
        }
    }
    
    return ret
}

let source: [Int] = [2, 7, 11, 15]

twoSum(source, target: 13)
