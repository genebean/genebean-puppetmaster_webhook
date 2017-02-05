require 'sinatra'
require 'json'

webhook_config = (Dir.pwd) + '/webhook_config.json'

if File.exists?(webhook_config)
  $config_obj = JSON.parse(File.read(webhook_config))
else
  raise "Configuration file: #{webhook_config} does not exist"
end

if $config_obj['slack_url'] then
  require 'slack-notifier'
end

set :bind, $config_obj['bind']

r10k_cmd        = $config_obj['r10k_cmd']
repo_control    = $config_obj['repo_control']
repo_puppetfile = $config_obj['repo_puppetfile']
repo_hieradata  = $config_obj['repo_hieradata']
$slack_url      = $config_obj['slack_url']

before do
  if env['HTTP_X_GITHUB_EVENT']
    logger.info('This message seems to be from GitHub')
    @request_source = 'GitHub'
  elsif env['HTTP_X_GITLAB_EVENT']
    logger.info('This message seems to be from GitLab')
    @request_source = 'GitLab'
  else
    logger.info('This message seems to be from somewhere unknown')
    @request_source = 'unknown'
  end
end

get '/' do
  raise Sinatra::NotFound
end

post '/test' do
  push = JSON.parse(request.body.read)
  #logger.info("json payload: #{push.inspect}")
  #logger.info("request env: #{request.env}")

  repo_name   = push['repository']['name']
  repo_ref    = push['ref']
  ref_array   = repo_ref.split('/')
  ref_type    = ref_array[1]
  branch_name = ref_array[2,ref_array.size].join('/')
  logger.info("repo name = #{repo_name}")
  logger.info("repo ref = #{repo_ref}")
  logger.info("branch = #{branch_name}")

  if repo_name == repo_control || repo_name == repo_puppetfile || repo_name == repo_hieradata
    logger.info("Deploying #{branch_name} environment with r10k")
  else
    module_name = repo_name.split('-').pop
    logger.info("Deploying #{branch_name} branch of puppet module #{module_name} with r10k")
  end
end

post '/payload' do
  push = JSON.parse(request.body.read)
  #logger.info("json payload: #{push.inspect}")
  #logger.info("request env: #{request.env}")

  repo_name   = push['repository']['name']
  repo_ref    = push['ref']
  ref_array   = repo_ref.split('/')
  ref_type    = ref_array[1]
  branch_name = ref_array[2,ref_array.size].join('/')
  logger.info("repo name = #{repo_name}")
  logger.info("repo ref = #{repo_ref}")
  logger.info("branch = #{branch_name}")

  # Check if repo_name is the control repo, where the Puppetfile lives, or where hiera data lives
  if repo_name == repo_control || repo_name == repo_puppetfile || repo_name == repo_hieradata
    logger.info("Deploying #{branch_name} environment with r10k")
    deploy_env(branch_name, r10k_cmd)
  else
    module_name = repo_name.split('-').pop
    logger.info("Deploying #{branch_name} branch of puppet module #{module_name} with r10k")
    deploy_module(module_name, r10k_cmd)
  end
end

def slack?
  !!$config_obj['slack_url']
end

def notify_slack(status_message)
  notifier = Slack::Notifier.new $slack_url

  if status_message[:branch]
    target = "environment #{status_message[:branch]}"
  elsif status_message[:module_name]
    target = "module #{status_message[:module_name]}"
  end

  message = {
      author: 'r10k for Puppet',
      title: "r10k deployment of Puppet #{target}"
  }

  case status_message[:status_code]
    when 200
      message.merge!(
          color: 'good',
          text: "Successfully deployed #{target}",
          fallback: "Successfully deployed #{target}"
      )
    when 500
      message.merge!(
          color: 'bad',
          text: "Failed to deploy #{target}",
          fallback: "Failed to deploy #{target}"
      )
  end

  notifier.post text: message[:fallback], attachments: [message]
end

def deploy_env(branchname, r10k_cmd)
  begin
    deploy_cmd = "#{r10k_cmd} deploy environment #{branchname} -pv"
    logger.info("Now running #{deploy_cmd}")

    message = `#{deploy_cmd}`
    logger.info("environment: #{branchname} message: #{message}")

    status_message =  {:status => :success, :message => message.to_s, :branch => branchname, :status_code => 200}
    status_message.to_json
  rescue => e
    logger.error("environment: #{branchname} message: #{e.message} trace: #{e.backtrace}")
    status 500
    status_message = {:status => :fail, :message => e.message, :trace => e.backtrace, :branch => branchname, :status_code => 500}
    notify_slack(status_message) if slack?
    status_message.to_json
  end
end

def deploy_module(modulename, r10k_cmd)
  begin
    deploy_cmd = "#{r10k_cmd} deploy module #{modulename} -v"
    logger.info("Now running #{deploy_cmd}")

    message = `#{deploy_cmd}`
    logger.info("module: #{modulename} message: #{message}")

    status_message = {:status => :success, :message => message.to_s, :module_name => modulename, :status_code => 200}
    notify_slack(status_message) if slack?
    status_message.to_json
  rescue => e
    logger.error("module: #{modulename} message: #{e.message} trace: #{e.backtrace}")
    status 500
    status_message = {:status => :fail, :message => e.message, :trace => e.backtrace, :module_name => modulename, :status_code => 500}
    notify_slack(status_message) if slack?
    status_message.to_json
  end
end
