# Znn

`Znn` is an Elixir implementation of a nearest-neighbors text classifier that uses 
the Normalized Compression Distance. This approach is detailed in

> [Jiang et al., _“Low-Resource” Text Classification: A Parameter-Free Classification Method with Compressors_](https://aclanthology.org/2023.findings-acl.426/)

## Basic usage

Provide a training sample of labeled text data in the form

```elixir
> training_set = [
    %{label: "clickbait", text: "21 Outrageously Creative Ways To Make Meatballs"},
    %{label: "non_clickbait", text: "H5N1 Avian Flu virus has mutated, study says"},
    ...
  ]
```

To predict the label of a new piece of text, call the `predict` function:

```elixir
> text = "10 Amazing Ways To Grow Bigger Pumpkins"
> Znn.predict(text, training_set)
"clickbait"
```

## Examples

See the included Livebooks in `/livebooks` for applications of `Znn` to public data sets.

## Todo

- [ ] Precompute the compression sizes and store them with the label and text. One-the-fly compression is a significant fraction of the prediction run time.
- [ ] Allow other other compression algorithms to be used, including no compression (identity function).
- [ ] Adaptively compute parallel chunk size through warm-up runs.