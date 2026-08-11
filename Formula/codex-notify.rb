class CodexNotify < Formula
  desc "Play local macOS sounds for Codex approvals and completed turns"
  homepage "https://github.com/KentoYana/codex-push-notification"
  url "https://github.com/KentoYana/codex-push-notification/releases/download/v0.2.0/codex-notify-0.2.0.tar.gz"
  sha256 "3149d2acbc317b4d8c405d12c2bc22c1cbff3eb5bdc0ec2e454ed3dbd679b10e"
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
    assert_match "codex-notify 0.2.0", shell_output("#{bin}/codex-notify --version")
  end
end
