require "spec_helper"

describe "bpm new" do

  describe "normal" do

    before do
      cd home
    end

    it "should create files" do
      bpm 'new', 'BpmTest'

      files = %w(LICENSE README.md index.html app/main.js BpmTest.json assets/bpm_packages.js assets/bpm_styles.css assets/BpmTest/app_package.js assets/BpmTest/app_styles.css)

      # output without coloration
      output = stdout.read.gsub(/\e\[\d+m/,'')

      files.each do |file|
        output.should =~ /create\s+#{file}$/
        home("bpm_test", file).should exist
      end
    end

    it "should fetch dependencies"
  
    it "should build"
  
    it "should not generate into existing directory" do
      FileUtils.mkdir 'bpm_test'
  
      bpm 'new', 'BpmTest'
  
      stdout.read.should_not include("create")
      `ls #{home("bpm_test")}`.should be_empty
    end
  
    it "should allow a path to be specified" do
      bpm 'new', 'BpmTest', '--path=DifferentLocation' and wait
  
      home("DifferentLocation").should exist
      home("DifferentLocation", "BpmTest.json").should exist
      home("DifferentLocation", "DifferentLocation.json").should_not exist
      home("bpm_test").should_not exist
    end
  
  end
  
  describe "package templates" do
  
    describe "with custom generator" do
  
      before do
        goto_home
        set_host
        start_fake(FakeGemServer.new)
      end
  
      it "should create custom files" do
        bpm 'new', 'BpmTest', '--package=custom_generator'
  
        files = %w(lib lib/main.js app.js BpmTest.json assets/bpm_packages.js assets/bpm_styles.css)
  
        # output without coloration
        output = stdout.read.gsub(/\e\[\d+m/,'')
  
        files.each do |file|
          output.should =~ /create\s+#{file}$/
          home("bpm_test", file).should exist
        end
      end
  
      it "should create custom app.js with explicit generator" do
        bpm 'new', 'BpmTest', '--package=custom_generator' and wait
  
        File.read(home("bpm_test", "app.js")).should == "require('BpmTest/main.js')\n"
      end
  
      it "should create custom project.json without explicit generator" do
        bpm 'new', 'BpmTest', '--package=core-test' and wait
  
        File.read(home("bpm_test", "BpmTest.json")).should =~ /"core-test": "0.4.9"/
      end
  
    end
  
    describe "with custom generator" do
  
      before do
        goto_home
        set_host
        start_fake(FakeGemServer.new)
      end
  
      it "should add package as a dependency even if it doesn't have custom generator" do
        bpm 'new', 'BpmTest', '--package=jquery' and wait
  
        File.read(home("bpm_test", "BpmTest.json")).should =~ /"dependencies": {\n\s+"jquery": "1.4.3"\n\s+}/
      end
  
    end
  
    it "should install the package if it doesn't exist locally"
  
  end

end
