class PostmarkMailer < ApplicationMailer
  def reset(user)
    @user = user
    mail(
      :to  => user.email,
      :from => 'system@m6.nz',
      :subject => 'Your Reset Code',
      :track_opens => 'true')
  end
  def verify(user)
    @user = user
    mail(
      :to  => user.email,
      :from => 'system@m6.nz',
      :subject => 'Your Validation Code',
      :track_opens => 'true')
  end
  def support(t, u)
    @t = t
    mail(
      :to  => u,
      :from => 'system@m6.nz',
      :subject => 'New reply to your ticket',
      :track_opens => 'true')
  end
  def support_admin(t, u)
    @t = t
    mail(
      :to  => u,
      :from => 'system@m6.nz',
      :subject => 'A new ticket has just been opened',
      :track_opens => 'true')
  end
end
