class Bibcollect < Formula
  desc "Collect and normalize exported bibliography files"
  homepage "https://github.com/KentoYana/bibcollect"
  url "https://github.com/KentoYana/bibcollect/releases/download/v1.1.0/bibcollect-1.1.0.tar.gz"
  sha256 "1a79e2bc4538dbae5e0a4944f98000e1373dc161aa36ad2059e612611634f9c8"
  license "MIT"

  depends_on "bibutils"
  depends_on "zsh"

  def install
    bin.install "bibcollect"
  end

  test do
    assert_match "bibcollect 1.1.0", shell_output("#{bin}/bibcollect --version")

    (testpath/"sample.bib").write("@article{sample, title={Sample}}\n")
    system bin/"bibcollect", "--yes", testpath
    assert_path_exists testpath/"today.bib"
    assert_match "@article{sample", (testpath/"today.bib").read
  end
end
