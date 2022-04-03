const path = require('path');

const http = require('http')

const watch = process.argv.includes('--watch')
const clients = []

const watchOptions = {
  onRebuild: (error, result) => {
    if (error) {
      console.error('Build failed:', error)
    } else {
      console.log('Build succeeded')
      // console.log(clients)
      clients.forEach((res) => res.write('data: update\n\n'))
      clients.length = 0
    }
  }
}

require("esbuild").build({
  entryPoints: ["application.js"],
  bundle: true,
  sourcemap: true,
  inject: [path.join(process.cwd(), "config/esbuild/react-shim.js")],
  outdir: path.join(process.cwd(), "app/assets/builds"),
  absWorkingDir: path.join(process.cwd(), "app/javascript"),
  watch: watch && watchOptions,
  loader: { '.js': 'jsx' },
  // custom plugins will be inserted is this array
  plugins: [],
  banner: {
    js: ' (() => new EventSource("http://localhost:8082").onmessage = () => location.reload())();',
  },
}).catch((err) => {
  console.error(err)
  process.exit(1)
});

http.createServer((req, res) => {
  return clients.push(
    res.writeHead(200, {
      "Content-Type": "text/event-stream",
      "Cache-Control": "no-cache",
      "Access-Control-Allow-Origin": "*",
      Connection: "keep-alive",
    }),
  );
}).listen(8082);