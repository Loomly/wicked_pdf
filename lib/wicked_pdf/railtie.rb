require 'wicked_pdf/pdf_helper'
require 'wicked_pdf/wicked_pdf_helper'
require 'wicked_pdf/wicked_pdf_helper/assets'

class WickedPdf
  if defined?(Rails.env)
    class WickedRailtie < Rails::Railtie
      initializer 'wicked_pdf.register', :after => 'remotipart.controller_helper' do |_app|
        # HACK: The introduction of this instrumentation block (to solve a Rails 6 deprecation warning)
        # is causing major issues with a ruby interpreter crash:
        #
        #   lib/action_controller/metal/rescue.rb:25: [BUG] Illegal instruction at 0x00007fff6fd9a1c2
        #
        # Removing the on_load line avoids this issue, but then gives rise to the Rails 6 deprecation
        # warning with zeitwerk. So for now we are disabling this auto-inclusion of modules entirely
        # and instead manually including WickedPdf::PdfHelper into any controller that renders PDFs,
        # and manually including WickedPdf::WickedPdfHelper::Assets into a helper used for PDFs.
        #
        # ActiveSupport.on_load(:action_controller) do
        #   if ActionController::Base.respond_to?(:prepend) &&
        #      Object.method(:new).respond_to?(:super_method)
        #     ActionController::Base.send :prepend, PdfHelper
        #   else
        #     ActionController::Base.send :include, PdfHelper
        #   end
        #   ActionView::Base.send :include, WickedPdfHelper::Assets
        # end
      end
    end

    if Mime::Type.lookup_by_extension(:pdf).nil?
      Mime::Type.register('application/pdf', :pdf)
    end

  end
end
