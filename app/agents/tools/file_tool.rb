require "fileutils"
require "agents"

class FileTool < Agents::Tool

  description "A tool for creating directories and writing content to files (HTML, CSS, JS). Use this for every file you need to create."

  param :directory_path, type: "string", desc: "The root directory path for the website. Should be unique per user/request."
  param :filename,       type: "string", desc: "The name of the file to create (e.g., 'index.html', 'style.css')."
  param :content,        type: "string", desc: "The full content to be written into the file."

  def perform(tool_context, directory_path:, filename:, content:)
    begin
      FileUtils.mkdir_p(directory_path)

      full_path = File.join(directory_path, filename)

      File.write(full_path, content)

      "Successfully wrote file: #{filename} to #{directory_path}"
    rescue => e
      "Error writing file #{filename}: #{e.message}"
    end
  end
end
