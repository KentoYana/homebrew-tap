class Spotscanner < Formula
  desc "Quantitative analysis of fungal spot-test plates"
  homepage "https://github.com/KentoYana/spotscanner"
  url "https://github.com/KentoYana/spotscanner/releases/download/v8.0.1/spotscanner-8.0.1.tar.gz"
  sha256 "14a38895dd6451a573dcbb74090edf18a944b4ab46d523dc6684832d58204fde"
  license "MIT"

  depends_on "python-setuptools" => :build
  depends_on "numpy"
  depends_on "opencv"
  depends_on "python@3.14"

  def install
    python = formula_opt_bin("python@3.14")/"python3.14"
    system python, "-m", "venv", "--system-site-packages", libexec
    system libexec/"bin/python", "-m", "pip", "install",
           "--no-deps", "--no-build-isolation", "."
    bin.install_symlink libexec/"bin/spotscanner"
  end

  test do
    assert_match "SpotScanner v#{version}", shell_output("#{bin}/spotscanner --version")

    python = libexec/"bin/python"
    system python, "-c", <<~PYTHON
      from importlib.resources import files

      import cv2
      import numpy as np

      marker = cv2.imread(str(files("spotscanner.resources.marker").joinpath("Marker16.png")))
      canvas = np.full((800, 1000, 3), 255, dtype=np.uint8)
      canvas[50:210, 50:210] = marker
      canvas[600:760, 800:960] = marker
      cv2.circle(canvas, (350, 350), 60, (0, 0, 0), -1)
      if not cv2.imwrite("plate.jpg", canvas):
          raise SystemExit("could not write test image")
    PYTHON

    assert_match "Marker16 Match!!!",
                 shell_output("#{bin}/spotscanner --analyze pipette --single plate.jpg")
    assert_path_exists testpath/"plate_converted.png"
    assert_equal 25, (testpath/"plate_results.csv").read.lines.count
  end
end
