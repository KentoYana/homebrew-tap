class Bibcollect < Formula
  desc "Collect and normalize exported bibliography files"
  homepage "https://github.com/KentoYana/BibCollect"
  url "https://github.com/KentoYana/BibCollect/releases/download/v1.1.1/bibcollect-1.1.1.tar.gz"
  sha256 "a4f8919518cda0871358f6defdca99e28ea762bdd1365276ec2560e8ceba4a63"
  license "MIT"
  revision 1

  depends_on "bibutils"

  on_linux do
    depends_on "zsh"
  end

  def install
    bin.install "bibcollect"
  end

  test do
    assert_match "bibcollect 1.1.1", shell_output("#{bin}/bibcollect --version")

    (testpath/"sample.bib").write("@article{sample, title={Sample}}\n")
    system bin/"bibcollect", "--yes", "--path", testpath
    assert_path_exists testpath/"today.bib"
    assert_match "@article{sample", (testpath/"today.bib").read
  end
end
