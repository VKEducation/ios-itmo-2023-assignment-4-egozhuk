import Foundation

//let ff = ThreadSafeArray<Int>()
//var dd = [1]
//dd.append(1)
//ff.dropFirst()

//let sd = ff[0]

//for index in 0..<100 {
//    ff.append(index)
//}
//
//print(ff.dropFirst(70))

let taskA = BasicTask(qos: .userInitiated)
let taskB = BasicTask(qos: .utility)
let taskC = BasicTask(qos: .background)

taskA.addDependency(taskB)
taskA.addDependency(taskC)

let taskManager = TaskManager()
taskManager.add(taskA)
taskManager.add(taskB)
taskManager.add(taskC)

taskManager.run()

RunLoop.current.run()
