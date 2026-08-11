class CodexNotify < Formula
  desc "Play local macOS sounds for Codex approvals and completed turns"
  homepage "https://github.com/KentoYana/codex-push-notification"
  url "https://github.com/KentoYana/codex-push-notification/releases/download/v0.1.0/codex-notify-0.1.0.tar.gz"
  sha256 "9b85ffe20bec27a52ba38cffa34bdc5f3d0d0c7961e4f3d94d2ef9bf988b97a5"
  license "MIT"

  depends_on :macos
  depends_on "python@3.13"

  def install
    python = formula_opt_bin("python@3.13")/"python3.13"
    inreplace "codex_notify.py", "#!/usr/bin/env python3", "#!#{python}"
    bin.install "codex_notify.py" => "codex-notify"
  end

  service do
    run [opt_bin/"codex-notify", "watch"]
    keep_alive true
    process_type :background
    log_path var/"log/codex-notify.log"
    error_log_path var/"log/codex-notify.log"
  end

  test do
    assert_match "codex-notify 0.1.0", shell_output("#{bin}/codex-notify --version")
  end
end
