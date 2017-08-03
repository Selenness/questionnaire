Sidekiq::Cron::Job.destroy_all!
Sidekiq::Cron::Job.create(name: 'Daily digest email', cron: '0 0 * * *', class: 'DigestJob')