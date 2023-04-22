require 'rails_helper'
RSpec.describe 'Courses API routing', type: :routing do
  it 'routes GET /courses to courses#index' do
    expect(get: '/courses').to route_to('courses#index')
  end

  it 'routes GET /courses/:id to courses#show' do
    expect(get: '/courses/1').to route_to('courses#show', id: '1')
  end

  it 'routes POST /courses to courses#create' do
    expect(post: '/courses').to route_to('courses#create')
  end

  it 'routes PATCH /courses/:id to courses#update' do
    expect(patch: '/courses/1').to route_to('courses#update', id: '1')
  end

  it 'routes PUT /courses/:id to courses#update' do
    expect(put: '/courses/1').to route_to('courses#update', id: '1')
  end

  it 'routes DELETE /courses/:id to courses#destroy' do
    expect(delete: '/courses/1').to route_to('courses#destroy', id: '1')
  end
end
