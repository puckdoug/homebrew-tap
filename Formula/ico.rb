class Ico < Formula
  desc "Convert images to favicon formats for web deployment"
  homepage "https://github.com/puckdoug/ico"
  url "https://github.com/puckdoug/ico/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "20315d4abf1de8fdd177a7dea47a1d4b23d85296f475fc4a541fc345349a1c95"
  license "MIT"
  head "https://github.com/puckdoug/ico.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "base64"
    # --version should report the formula's version.
    assert_match version.to_s, shell_output("#{bin}/ico --version")

    # Minimal valid 1x1 PNG (same bytes as tests/fixtures/test.png).
    png_b64 = "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAIAAACQd1PeAAAADElEQVR4nGP4z8AAAAMBAQDJ/pLvAAAAAElFTkSuQmCC"
    (testpath/"input.png").write(Base64.decode64(png_b64))

    outdir = testpath/"out"
    outdir.mkpath
    system bin/"ico", "--output", outdir, testpath/"input.png"

    ico = outdir/"favicon.ico"
    assert_path_exists ico, "favicon.ico was not produced"
    assert_equal "\x00\x00\x01\x00".b, ico.binread(4), "invalid ICO header"
  end
end
