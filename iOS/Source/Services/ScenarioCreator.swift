import Foundation

final class ScenarioCreator {
    var events = [Event]()
    var timer: Timer?

    func executeScenario() {
        self.events = randomSessionEvents()
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

        events.append(Event(type: .response, delay: self.randomEventDelay()))

        return events
    }

    private func randomEventDelay() -> Double {
        return Double(arc4random_uniform(10)) + 3
    }

    private func schedule(event: Event) {
        self.timer?.invalidate()
        self.timer = nil
        self.timer = Timer.scheduledTimer(timeInterval: event.delay, target: self, selector: #selector(self.timerAction(_:)), userInfo: ["event" : event], repeats: false)
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
            print("Message delivered")
        case .read:
            print("Message read")
        case .type:
            print("Typing...")
        case .pause:
            print("😶")
        case .response:
            print("Response")
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

