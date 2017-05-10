import Foundation

protocol ScenarioDelegate: class {
    func didResponse(on scenario: Scenario)
    func didPause(on scenario: Scenario)
    func didType(on scenario: Scenario)
    func didReadMessage(on scenario: Scenario)
    func didDeliverMessage(on scenario: Scenario)
}

extension ScenarioDelegate {
    func didDeliverMessage(on scenario: Scenario) { print("Delivered")}
    func didReadMessage(on scenario: Scenario) { print("Read")}
    func didPause(on scenario: Scenario) { print("😶")}
    func didType(on scenario: Scenario) { print("Typing ...")}
    func didResponse(on scenario: Scenario) { print("Tell the time!")}
}

final class Scenario {
    weak var delegate: ScenarioDelegate?

    var events = [Event]()
    var timer: Timer?
    private(set) var timeString = ""

    func createScenario() {
        self.events = randomSessionEvents()
    }
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:ss"
        
        return dateFormatter
    }()

    func executeScenario() {
        if let firstEvent = self.events.first {
            schedule(event: firstEvent)
        }
    }

    private func randomSessionEvents() -> [Event] {

        var events = [Event]()
        events.append(Event(type: .delivered, delay: self.randomEventDelay()))
        events.append(Event(type: .read, delay: self.randomEventDelay()))

        for _ in 0...Int(arc4random_uniform(2) + 1) {
            events.append(Event(type: .pause, delay: self.randomEventDelay()))
            events.append(Event(type: .type, delay: self.randomEventDelay()))
        }
        events.append(Event(type: .pause, delay: self.randomEventDelay()))
        events.append(Event(type: .response, delay: 0.1))

        return events
    }

    private func randomEventDelay() -> Double {
        return Double(arc4random_uniform(5)) + 3
    }

    private func schedule(event: Event) {
        self.timer?.invalidate()
        self.timer = nil
        self.timer = Timer.scheduledTimer(timeInterval: event.delay, target: self, selector: #selector(self.timerAction(_:)), userInfo: ["event" : event], repeats: false)
        
        self.testje
    }

    //MARK: - Execute event

    @objc func timerAction(_ timer: Timer) {
        if let event = (timer.userInfo as? [String: Any])?["event"] as? Event {
            self.execute(event: event)   // logic for particular event

            for newEvent in self.events {
                if newEvent.executed == false {
                    self.schedule(event: newEvent)
                    break
                }
            }
        }
    }

    private  func execute(event: Event) {
        switch event.type {
        case .delivered:
            self.delegate?.didDeliverMessage(on: self)
        case .read:
            self.delegate?.didReadMessage(on: self)
        case .type:
            self.delegate?.didType(on: self)
        case .pause:
            self.delegate?.didPause(on: self)
        case .response:
            self.timeString = self.dateFormatter.string(from: Date())
            self.delegate?.didResponse(on: self)
        default: break
        }

        event.executed = true
    }

}

enum EventType: Int {
    case none, delivered, read, type, pause, response
}

class Event {
    private(set) var delay: Double
    private(set) var type: EventType = .none
    var executed = false

    init(type: EventType, delay: Double) {
        self.type = type
        self.delay = delay
    }
}
