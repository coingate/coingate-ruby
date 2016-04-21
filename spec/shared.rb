RSpec.shared_context 'shared' do
  before(:all) do
    @authentication = {
        app_id:     1,
        api_key:    'iob0ctFgeHLajvfxzYnIPB',
        api_secret: 'ytaqXRWZ17ONlpshPTQuF50rIVLwBbmi',
        environment: 'sandbox'
    }
  end
end