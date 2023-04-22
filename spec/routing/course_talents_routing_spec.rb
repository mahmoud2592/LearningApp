require 'rails_helper'

RSpec.describe 'CourseTalents routing', type: :routing do
  it 'routes to #index' do
    expect(get: '/course_talents').to route_to('course_talents#index')
  end

  it 'routes to #show' do
    expect(get: '/course_talents/1').to route_to('course_talents#show', id: '1')
  end

  it 'routes to #create' do
    expect(post: '/course_talents').to route_to('course_talents#create')
  end

  it 'routes to #update via PUT' do
    expect(put: '/course_talents/1').to route_to('course_talents#update', id: '1')
  end

  it 'routes to #update via PATCH' do
    expect(patch: '/course_talents/1').to route_to('course_talents#update', id: '1')
  end

  it 'routes to #destroy' do
    expect(delete: '/course_talents/1').to route_to('course_talents#destroy', id: '1')
  end
end
