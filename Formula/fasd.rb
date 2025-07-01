class Fasd < Formula
  desc "CLI tool for quick access to files and directories"
  homepage "https://github.com/clvv/fasd"
  url "https://github.com/clvv/fasd/archive/refs/tags/1.0.1.tar.gz"
  sha256 "88efdfbbed8df408699a14fa6c567450bf86480f5ff3dde42d0b3e1dee731f65"
  license "MIT"
  head "https://github.com/clvv/fasd.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/new-life"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "b1ee8fe319bb5e656de643fb65eb408022db70f8b90a891db21dd2839b59b9bb"
    sha256 cellar: :any_skip_relocation, ventura:      "4393326c2c962ef75f87d60fbaba2bbac447d6e11542c56da384fd1526b2e343"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "9fd44bcdb31c67bcfc875c40e115a5156db699e52fd284243f0b13c363ea2718"
  end

  def install
    bin.install "fasd"
    man1.install "fasd.1"
  end

  test do
    system bin/"fasd", "--init", "auto"
  end
end
