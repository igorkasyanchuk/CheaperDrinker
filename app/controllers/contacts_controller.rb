class ContactsController < InheritedResources::Base
  before_filter :store_location
  
  def index
    redirect_to new_contact_path
  end
  
  def create
    @contact = Contact.new(params[:contact])
    _captcha_valid = recaptcha_valid?
    logger.info _captcha_valid
    logger.info _captcha_valid
    logger.info _captcha_valid
    if _captcha_valid && @contact.save
      redirect_to root_path, :notice => "You message sent successfully."
    else
      render :new
    end
  end
  
end
