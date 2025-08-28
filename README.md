# ruby-mcp
A dynamic and flexible Ruby MCP server built on [FastMCP](https://github.com/yjacquin/fast-mcp).

This gem is a Ruby MCP server in a box. It's designed to allow you to get a new MCP server up and running in just a few minutes, and add tools, resources and prompts with as little effort as possible.

Once DynamicMCP is deployed within the directory you want it to work in, it builds the necessary code to expose resources and prompts to an AI agent dynamically. All you need to do is drop in the markdown or ruby files that you want to be exposed, and Ruby MCP does the rest.

For tools, DynamicMCP allows you to simply drop in ruby files that contain FastMCP tool classes and it will automatically require them and register them to be available to the AI agent. For resources, you can drop in markdown files with the proper front matter or drop in Ruby classes that implement a resource using FastMCP. For prompts, only markdown files are supported for the time being and they get exposed as tools, but once FastMCP supports prompts then DynamicMCP will also support them.

## Installation

```bash
gem install dynamic_mcp
```

Then inside the directory where you want the mcp server to exist:

```bash
deploy_dynamic_mcp
```

The above command will install files into the `./mcp` directory, asking you if you want to override them if they already exist. When it is finished, it will output the path to the MCP server start up file so that you may configure your AI agents to use it.

For example, to configure gemini to use your new MCP server, you would put the following in your `.gemini/settings.json` file:

```json
{
  "mcpServers": [
    {
      "name": "dynamic_mcp_server",
      "command": "ruby",
      "args": ["path/to/mcp/server.rb"],
      "cwd": "path/to/mcp",
      "timeout": 30000,
      "trust": false
    }
  ]
}
```

## Usage

With the MCP server installed and your agent configured to use it, you can now drop `.md` or `.rb` files into `./mcp/resources` and `./mcp/prompts` and `.rb` files into `./mcp/tools` and they will automatically be exposed to the agent via the server. Just be sure to follow the below guides for each type of file.

### Tools

Tool files must be `.rb` files that define a class that inherits form `::FastMCP::Tool`. An example file is generated as part of the installation inside the `./mcp/tools` directory. See the [FastMCP github page](https://github.com/yjacquin/fast-mcp) for more about how to implement a tool in Ruby.

### Resources

Resources can either be ruby classes that inherit from `::FastMCP::Resource` or markdown files, in which case the ruby classes will be dynamically defined to serve the contents of the file to the agent.

#### Resource Markdown Files

Resources are simply markdown files that have a frontmatter section to help facilitate registering them with the MCP server. That front matter should look like this:

```markdown
---
resource_name: "example"
uri: "dynamic_mcp:///example"
mime_type: "text/markdown"
---
```

The `uri` attribute should be unique, as this is how the AI agent can invoke specific resources.

### Prompts

`FastMCP` does not yet support prompts so they are simply implemented as tools and will show up as tools to the agent. To add a prompt using DynamicMCP, simply drop a markdown file with the proper front matter into `./mcp/prompts`. The frontmatter should look like this:

```markdown
---
description: "This prompt instructs the AI agent to meow three times"
name: "Meow"
---
```

The `name` attribute should be unique, as this is how the AI agent can invoke specific prompts.

### Integration

The `./mcp` directory is meant to be committed to a repository and/or shared. The server within it is an independent ruby application that simply needs its dependencies available on the system on which it runs. The globally installed gem knows nothing about the servers it creates.

#### Gemini CLI

The Gemini CLI client currently has a [bug that effects MacOS](https://github.com/google-gemini/gemini-cli/issues/3261). This bug is impacting all mcp servers and requires that the Gemini client is started in the same root directory as you deploy the MCP server.

For now, it is recommended to deploy the MCP server into a top level directory that contains all the projects you wish to work on while using it.

