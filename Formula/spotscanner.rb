class Spotscanner < Formula
  desc "Quantitative analysis of fungal spot-test plates"
  homepage "https://github.com/KentoYana/spotscanner"
  url "https://github.com/KentoYana/spotscanner/releases/download/v8.0.1/spotscanner-8.0.1.tar.gz"
  sha256 "14a38895dd6451a573dcbb74090edf18a944b4ab46d523dc6684832d58204fde"
  license "MIT"
  revision 1

  depends_on "python-setuptools" => :build
  depends_on "numpy"
  depends_on "opencv"
  depends_on "python@3.15"

  def install
    python = formula_opt_bin("python@3.15")/"python3.15"
    system python, "-m", "venv", "--system-site-packages", libexec
    # Fail at installation if Homebrew moves a shared extension to another Python ABI.
    system libexec/"bin/python", "-c", "import cv2; import numpy"
    # pip distributions keep their exact pins; this Formula uses Homebrew libraries.
    system libexec/"bin/python", "-m", "pip", "install",
           "--no-deps", "--no-build-isolation", "."
    bin.install_symlink libexec/"bin/spotscanner"
  end

  test do
    assert_match "SpotScanner v#{version}", shell_output("#{bin}/spotscanner --version")

    python = libexec/"bin/python"
    system python, "-c", <<~PYTHON
      from importlib.resources import files
      from pathlib import Path
      import sys

      import cv2
      import numpy as np

      assert sys.version_info[:2] == (3, 15), sys.version
      assert Path(cv2.__file__).resolve().is_relative_to(Path("#{formula_opt_prefix("opencv")}").resolve())
      assert Path(np.__file__).resolve().is_relative_to(Path("#{formula_opt_prefix("numpy")}").resolve())
      print(f"Python {sys.version}; OpenCV {cv2.__version__}; NumPy {np.__version__}")
      print(f"cv2: {cv2.__file__}; numpy: {np.__file__}")

      marker = cv2.imread(str(files("spotscanner.resources.marker").joinpath("Marker16.png")))
      assert marker is not None, "packaged marker could not be decoded"
      canvas = np.full((800, 1000, 3), 255, dtype=np.uint8)
      canvas[50:210, 50:210] = marker
      canvas[600:760, 800:960] = marker
      cv2.circle(canvas, (350, 350), 60, (0, 0, 0), -1)
      for mode in ("pipette", "replicator"):
          assert cv2.imwrite(f"{mode}.jpg", canvas), "could not write test image"
    PYTHON

    %w[pipette replicator].each do |mode|
      assert_match "Marker16 Match!!!",
                   shell_output("#{bin}/spotscanner --analyze #{mode} --single #{mode}.jpg")
      assert_path_exists testpath/"#{mode}_converted.png"
    end

    system python, "-c", <<~PYTHON
      import csv
      from decimal import Decimal

      import cv2

      # Two-decimal synthetic reference values, cross-checked with the pinned pip runtime.
      # A numerical drift should be investigated, not accepted by updating these silently.
      expected = {
          "pipette": (4, 6, {
              (1, 1): "79.84", (1, 2): "96.08", (2, 2): "99.06",
              (2, 3): "39.5", (3, 3): "86.86",
          }),
          "replicator": (8, 12, {
              (1, 1): "57.0", (1, 2): "40.32", (1, 3): "71.0",
              (2, 1): "86.68", (2, 2): "69.0", (2, 3): "91.03",
              (3, 5): "98.99", (3, 6): "99.92",
              (4, 4): "97.49", (4, 5): "11.17", (4, 6): "39.66",
              (5, 4): "98.89", (5, 5): "30.48", (5, 6): "54.8",
          }),
      }
      for mode, (height, width, values) in expected.items():
          image = cv2.imread(f"{mode}_converted.png")
          assert image is not None, f"{mode}: diagnostic image could not be decoded"
          assert image.shape == (574, 774, 3), (mode, image.shape)
          with open(f"{mode}_results.csv", newline="") as handle:
              reader = csv.DictReader(handle)
              assert reader.fieldnames == ["Time", "Image", "Threshold", "row", "column", "Colony"]
              rows = list(reader)
          assert len(rows) == height * width, (mode, len(rows))
          coordinates = [(r, c) for r in range(1, height + 1) for c in range(1, width + 1)]
          assert [(int(row["row"]), int(row["column"])) for row in rows] == coordinates
          for row, coordinate in zip(rows, coordinates):
              assert row["Time"], (mode, row)
              assert row["Image"] == mode, (mode, row)
              assert row["Threshold"] == "7", (mode, row)
              actual = Decimal(row["Colony"])
              assert actual.is_finite() and 0 <= actual <= 100, (mode, row)
              assert actual == Decimal(values.get(coordinate, "100")), (mode, row)
          print(f"{mode}: {len(rows)} cells, exact numerical reference and PNG verified")
    PYTHON
  end
end
