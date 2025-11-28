
import Foundation
import Combine

final class RecipeDetailViewModel: ObservableObject {
    @Published var stepIndex: Int = 0
    @Published var isTimerRunning: Bool = false
    @Published var remainingSeconds: Int = 0

    private var timer: AnyCancellable?

    func startTimer(minutes: Int) {
        remainingSeconds = minutes * 60
        isTimerRunning = true
        timer?.cancel()
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self else { return }
                if self.remainingSeconds > 0 {
                    self.remainingSeconds -= 1
                } else {
                    self.isTimerRunning = false
                    self.timer?.cancel()
                }
            }
    }

    func stopTimer() {
        isTimerRunning = false
        timer?.cancel()
    }
}
