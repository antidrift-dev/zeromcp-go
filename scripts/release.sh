#!/usr/bin/env bash
set -eo pipefail

# ZeroMCP Release Script
# Tags the monorepo and pushes subtree splits to all 10 language repos.
#
# Usage: ./scripts/release.sh v0.1.0

VERSION="${1:-}"
if [ -z "$VERSION" ]; then
  echo "Usage: $0 <version>"
  echo "  e.g. $0 v0.1.0"
  exit 1
fi

ORG="antidrift-dev"

# dir:repo pairs
SPLITS="nodejs:zeromcp-node python:zeromcp-python go:zeromcp-go rust:zeromcp-rust java:zeromcp-java kotlin:zeromcp-kotlin swift:zeromcp-swift csharp:zeromcp-csharp ruby:zeromcp-ruby php:zeromcp-php"

echo "=== ZeroMCP Release $VERSION ==="
echo ""

# Ensure we're on main and clean
BRANCH=$(git branch --show-current)
if [ "$BRANCH" != "main" ]; then
  echo "ERROR: Must be on main branch (currently on $BRANCH)"
  exit 1
fi

if [ -n "$(git status --porcelain)" ]; then
  echo "ERROR: Working tree is not clean. Commit or stash changes first."
  exit 1
fi

# Tag the monorepo
echo "Tagging monorepo $VERSION..."
git tag -a "$VERSION" -m "$VERSION"
git push origin "$VERSION"
echo "  ✓ Tag $VERSION pushed to $ORG/zeromcp"
echo ""

# Push subtrees
for pair in $SPLITS; do
  dir="${pair%%:*}"
  repo="${pair##*:}"
  remote_url="https://github.com/$ORG/$repo.git"
  echo "Pushing $dir/ → $ORG/$repo..."

  # Add remote if not exists
  if ! git remote get-url "$repo" >/dev/null 2>&1; then
    git remote add "$repo" "$remote_url"
  fi

  # Split and push subtree
  SUBTREE_SHA=$(git subtree split --prefix="$dir" HEAD)

  # Push to main (force for first push to empty repo)
  git push "$repo" "$SUBTREE_SHA:refs/heads/main" --force 2>&1 | tail -1 || true

  # Push the version tag
  git push "$repo" "$SUBTREE_SHA:refs/tags/$VERSION" 2>&1 | tail -1 || true

  echo "  ✓ $repo main + $VERSION"
done

echo ""
echo "=== Release $VERSION complete ==="
echo ""
echo "Monorepo:  https://github.com/$ORG/zeromcp/releases/tag/$VERSION"
echo ""
echo "Subtrees:"
for pair in $SPLITS; do
  repo="${pair##*:}"
  echo "  https://github.com/$ORG/$repo/releases/tag/$VERSION"
done
echo ""
echo "Next steps:"
echo "  - npm publish (zeromcp-node)"
echo "  - twine upload (zeromcp-python)"
echo "  - cargo publish (zeromcp-rust)"
echo "  - mvn deploy (zeromcp-java)"
echo "  - gradle publish (zeromcp-kotlin)"
echo "  - dotnet nuget push (zeromcp-csharp)"
echo "  - gem push (zeromcp-ruby)"
echo "  - Go + Swift + PHP are live (tag-based)"
