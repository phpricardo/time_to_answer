namespace :dev do
  PASSWORD_DEFAULT = 123456
  DEFAULT_FILES_PATH = File.join(Rails.root, 'lib', 'tmp')

  desc "Configura o ambiente de desenvolvimento"
  task setup: :environment do
    if Rails.env.development?
      show_spinner("Apagando banco de dados...") { %x(rails db:drop) }
      show_spinner("Criando o banco de dados...") { %x(rails db:create) }
      show_spinner("Migrando o banco de dados...") { %x(rails db:migrate) }
      show_spinner("Criando o Administrador padrão...") { %x(rails dev:add_default_admin) }
      show_spinner("Criando Administradores extras...") { %x(rails dev:add_extra_admins) }
      show_spinner("Criando o Usuário padrão...") { %x(rails dev:add_default_user) }
      show_spinner("Cadastrando assuntos padrões...") { %x(rails dev:add_subjects) }
    else 
      puts "Você não está em ambiente de desenvolvimento."
    end
  end

  desc "Adiciona o administrador padrão"
    task add_default_admin: :environment do
      Admin.create!(
        email: 'admin@admin.com',
        password: PASSWORD_DEFAULT,
        password_confirmation: PASSWORD_DEFAULT
      )
    end

  desc "Adiciona o usuário padrão"
    task add_default_user: :environment do
      User.create!(
        email: 'user@user.com',
        password: PASSWORD_DEFAULT,
        password_confirmation: PASSWORD_DEFAULT
      )
    end

  desc "Adiciona administradores extras"
    task add_extra_admins: :environment do
      10.times do |i|
      Admin.create!(
        email: Faker::Internet::email,
        password: PASSWORD_DEFAULT,
        password_confirmation: PASSWORD_DEFAULT
      )
      end
    end

  desc "Adiciona assuntos padrão"
    task add_subjects: :environment do
    file_name = 'subjects.txt'
    file_path = File.join(DEFAULT_FILES_PATH, file_name)
   
    File.open(file_path, 'r').each do |line|
    Subject.create!(description: line.strip)
    end
  end
  
  private 
  
  def show_spinner(msg_start, msg_end = "Concluído!") 
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
    spinner.auto_spin
    yield
    spinner.success("(#{msg_end})")
  end
end
