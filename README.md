# Maven Deployment Cookbook

This cookbook help you easy to deploy your maven project into server

## Requirements

cookbook 'apt'
cookbook 'java'
cookbook 'maven'

e.g.
### Platforms

- SandwichOS
- Ubuntu
- Fedora
- CentOS

### Chef

- Chef 12.0 or later

### Cookbooks

## Attributes


e.g.
### exchange-expert::default

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['maven-deploy']['dir']</tt></td>
    <td>String</td>
    <td>Location to deploy</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
      <td><tt>['maven-deploy']['jar']</tt></td>
      <td>String</td>
      <td>Final Jar name</td>
      <td><tt>true</tt></td>
  </tr>
  <tr>
        <td><tt>['maven-deploy']['profile']</tt></td>
        <td>String</td>
        <td>Active Spring profile</td>
        <td><tt>true</tt></td>
  </tr>

  <tr>
        <td><tt>['maven-deploy']['git']['url']</tt></td>
        <td>String</td>
        <td>Your git repository</td>
        <td><tt>true</tt></td>
  </tr>
  <tr>
          <td><tt>['maven-deploy']['git']['branch']</tt></td>
          <td>String</td>
          <td>Your git branch</td>
          <td><tt>true</tt></td>
    </tr>


</table>

## Usage

### maven-deploy::default

TODO: Write usage instructions for each cookbook.

e.g.
Just include `maven-deploy` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[maven-deploy]"
  ]
}
```

## Contributing

e.g.
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

## License and Authors

Authors: glmanhtu

