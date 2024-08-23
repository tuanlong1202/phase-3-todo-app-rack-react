require 'pry'
require 'json'

class Application

  def call(env)
    resp = Rack::Response.new
    req = Rack::Request.new(env)

    # root url
    if req.path == '/'
      return [
        200,
        { 'content-type' => 'application/json' },
        [{ message: "you're on the home page" }.to_json]
      ]

    # get all resources 
    else 
      if req.path.match('/tasks')
        if (req.get?)
          task_id = req.path.split("/tasks/").last
          if (task_id.to_i > 0)
            t = Task.find_by(id:task_id)
            return  [200, { 'content-type'=> 'application/json'}, [t.to_json]]
          else 
            return  [200, { 'content-type'=> 'application/json'}, [Task.all.to_json]]
          end
        elsif (req.post?)
          t = Task.new()
          t.create_with_attributes(to_hash(req.body.read.to_s))
          return  [200, { 'content-type'=> 'application/json'}, [t.to_json]]
        elsif ((req.patch?) || (req.put?))
          task_id = req.path.split("/tasks/").last
          if (task_id.to_i > 0)
            t = Task.find_with_id(task_id)
            t.update_with_attributes(to_hash(req.body.read.to_s))
            return  [200, { 'content-type'=> 'application/json'}, [t.to_json]]
          end
        elsif (req.delete?)
          task_id = req.path.split("/tasks/").last
          if (task_id.to_i > 0)
            t = Task.delete_by_id(task_id)
            return  [200, { 'content-type'=> 'application/json'}, ["delete " + task_id]]
          end
        end
      elsif req.path.match('/categories')
        if (req.get?) 
          category_id = req.path.split("/categories/").last
          if (category_id.to_i > 0) 
            return  [200, { 'content-type'=> 'application/json'}, [category_id.to_json]]
          else 
            return  [200, { 'content-type'=> 'application/json'}, [Category.all.to_json]]
          end
        elsif (req.post?)
          return  [200, { 'content-type'=> 'application/json'}, [req.body.read]]
        elsif ((req.put?) || (req.patch?))
          category_id = req.path.split("/categories/").last
          if (category_id.to_i > 0)
            return  [200, { 'content-type'=> 'application/json'}, [req.body.read]]
          end
        elsif (req.delete?)
          category_id = req.path.split("/categories/").last
          if (category_id.to_i > 0)
            return  [200, { 'content-type'=> 'application/json'}, ["delete " + category_id]]
          end
        end
      end
    end

    resp.finish
  end

  def to_hash(str,arr_sep=',', key_sep=':')
    array = str.split(arr_sep)
    hash = {}

    array.each do |e|
      if (e.index(':'))
        key_value = e.delete("\n,{,},',\",`").split(key_sep)
        key_value[1].strip!
        hash[key_value[0].delete(" ")] = key_value[1]
      end
    end

    return hash
  end
  
end

