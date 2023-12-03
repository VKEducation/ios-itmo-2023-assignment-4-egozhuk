import Foundation

protocol Task: AnyObject {
    var qos: DispatchQoS.QoSClass { get }
    var dependencies: [Task] { get set }
    var isCompleted: Bool { get set }

    func addDependency(_ task: Task)
    func execute(completion: @escaping () -> Void)
}

class BasicTask: Task {
    let qos: DispatchQoS.QoSClass
    var dependencies: [Task] = []
    var isCompleted: Bool = false

    init(qos: DispatchQoS.QoSClass) {
        self.qos = qos
    }

    func addDependency(_ task: Task) {
        dependencies.append(task)
    }

    func execute(completion: @escaping () -> Void) {
        print("Task with QoS \(qos) is executed.")
        isCompleted = true
        completion()
    }
}

class TaskManager {
    private var tasks: [Task] = []

    func add(_ task: Task) {
        tasks.append(task)
    }

    func run() {
        let group = DispatchGroup()

        for task in tasks.sorted(by: { $0.qos.rawValue.rawValue > $1.qos.rawValue.rawValue }) {
            if !task.isCompleted && !task.dependencies.isEmpty {
                group.enter()
                executeTask(task, group: group)
            }
        }

        group.notify(queue: DispatchQueue.main) {
            print("All tasks are completed.")
        }
    }

    private func executeTask(_ task: Task, group: DispatchGroup) {
        let dependencyGroup = DispatchGroup()

        for dependency in task.dependencies {
            dependencyGroup.enter()
            executeTask(dependency, group: dependencyGroup)
        }

        dependencyGroup.notify(queue: DispatchQueue.global(qos: task.qos)) {
            guard !task.isCompleted else {
                group.leave()
                return
            }
            task.execute {
                group.leave()
            }
        }
    }
}
