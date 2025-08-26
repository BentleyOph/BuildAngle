class MockWebsiteGenerator
  def initialize(website_request)
    @website_request = website_request
    @business_name = website_request.business_name || "Your Company"
    @business_type = website_request.business_type || "Business"
  end

  def call
    @website_request.generated_pages.destroy_all

    create_homepage
    create_about_page
    create_services_page
    create_contact_page
    create_extra_page

    @website_request.update(status: "complete")
  end

  private

  def create_homepage
    content = "<h1>Welcome to #{@business_name}</h1><p>The best #{@business_type} in town.</p>"
    @website_request.generated_pages.create!(title: "Homepage", content: content)
  end

  def create_about_page
    content = "<h1>About #{@business_name}</h1><p>We have been in business for 10 years.</p>"
    @website_request.generated_pages.create!(title: "About", content: content)
  end

  def create_services_page
    content = "<h1>Our Services</h1><p>We offer a wide range of services for #{@business_type.pluralize}.</p>"
    @website_request.generated_pages.create!(title: "Services", content: content)
  end

  def create_contact_page
    content = "<h1>Contact Us</h1><p>Email us at contact@#{@business_name.parameterize}.com</p>"
    @website_request.generated_pages.create!(title: "Contact", content: content)
  end

  def create_extra_page
    content = "<h1>Our Blog</h1><p>Read our latest news.</p>"
    @website_request.generated_pages.create!(title: "Blog", content: content)
  end
end
