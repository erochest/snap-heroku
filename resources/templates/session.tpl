<html>
  <head>
    <title>Session Page</title>
    <style type='text/css'>
      label { display: block; }
    </style>
  </head>
  <body>
    <div id="content">
      <h1>Session Values</h1>
      <ul>
        <sessionvals>
          <li><strong><key /></strong> => '<code><value /></code>'</li>
        </sessionvals>
      </ul>

      <h1>Add Value</h1>
      <form method="GET" action="/session/">
        <div>
          <label for="key">Key</label>
          <input name="key" id="key" type="text" />
        </div>
        <div>
          <label for="value">Value</label>
          <input name="value" id="value" type="text" />
        </div>
        <div>
          <input type="submit" />
        </div>
      </form>
      <div>
        <a href="/session/clear">Blast the session!</a> — <a href="../">Back</a>
      </div>
    </div>
  </body>
</html>
