
require 'vagrant'
require 'fileutils'

BROKEN_RECIPES = %w{opscode/windows opscode/firewall}

task :default => :usage

task :usage do
  puts "You forgot to tell the computer what to do; try one of these commands:"
  system("rake -T")
end

desc 'Down the cookbooks needed to provision everything.'
task :cookbooks do
  Dir.mkdir('cookbooks') unless File.directory?('cookbooks')

  system('git clone https://github.com/opscode/cookbooks.git cookbooks/opscode')
  system('git clone https://github.com/scholarslab/cookbooks.git cookbooks/slab')

  BROKEN_RECIPES.each do |recipe|
    if File.directory?("cookbooks/#{recipe}")
      FileUtils.remove_dir("cookbooks/#{recipe}", true)
    end
  end
end

desc 'Initializes the environment.'
task :init => :cookbooks do
  puts 'vagrant up'
  env = Vagrant::Environment.new
  env.cli('up')
end

desc 'Cleans everything out of the environment.'
task :clobber do
  FileUtils.rmtree %w{cookbooks slab-cookbooks}, :verbose => true
  puts 'vagrant destroy'
  env = Vagrant::Environment.new
  env.cli('destroy')
end

desc 'Do a safe halt on the VM.'
task :halt do
  env = Vagrant::Environment.new
  puts 'vagrant ssh sudo halt'
  env.primary_vm.ssh.execute do |ssh|
    ssh.exec!('sudo halt') do |channel, stream, data|
      print data
      $stdout.flush
    end
  end
end

desc "cat /tmp/vagrant-chef/chef-stacktrace.out."
task :chefst do
  env = Vagrant::Environment.new
  raise "Must run `vagrant up`" if !env.primary_vm.created?
  raise "Must be running!" if !env.primary_vm.vm.running?
  puts "Getting chef stacktrace."
  env.primary_vm.ssh.execute do |ssh|
    ssh.exec!("cat /tmp/vagrant-chef-4/chef-stacktrace.out") do |channel, stream, data|
      puts data
    end
  end
end

desc 'Runs the snappy server.'
task :serve do
  sh "./snappy -p 80 +RTS -N4"
end

