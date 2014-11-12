require 'rails_helper'
describe 'rails routes' do

  it 'routes Sale GET requet' do
    expect(get: '/sales').not_to be_routable
  end

  it 'routes Sale PUT requet' do
    expect(put: '/sales/123').not_to be_routable
  end

  it 'routes Sale GET requet' do
    expect(get: '/sales/123').to route_to(action: 'show', controller: 'sales', id: '123')
  end

  it 'routes Sale GET requet' do
    expect(post: '/sales').to route_to(action: 'create', controller: 'sales')
  end

  it 'routes Sale DELETE requet' do
    expect(delete: '/sales/123').to route_to(action: 'destroy', controller: 'sales', id: '123')
  end

end
